class OrdersController < ApplicationController
  before_action :sale_orders, only: [:create, :checkout]

  def create
    sfx_pack = SfxPack.find(params[:pack_id])

    if current_user

      current_sales = Sale.where("end_date > ?", Date.current)
      current_sales.each do |sale|
        sale.packs.each do |pack_id|
          @discount = sale.percentage if sfx_pack.id == pack_id
        end
      end

      if @discount
        sfx_pack_price = sfx_pack.price * ((100 - @discount) / 100.to_f)
      else
        sfx_pack_price = sfx_pack.price
      end
      order = Order.create!(product_link: sfx_pack.product_link, sfx_pack: sfx_pack, amount: sfx_pack_price, status: 'pending', user: current_user, sales: @sale_orders)
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: sfx_pack.title,
          images: [sfx_pack.photos[0]],
          amount: (sfx_pack_price.to_i * 100),
          currency: 'usd',
          quantity: 1
        }],
        allow_promotion_codes: true,
        success_url: dashboard_url,
        cancel_url: destroy_order_url
      )

      order.update(checkout_session_id: session.id)
      redirect_to new_order_payment_path(order)
    else
      redirect_to(new_user_session_path)
    end
  end

  def checkout
    cart = Cart.where(user_id: current_user.id).first

    cart.items.count == 1 ? multiple = false : multiple = true

    ordered_list = []
    cart.items.each do |item|
      ordered_list << SfxPack.find(item)
    end
    ordered_list.sort_by!(&:price_cents).reverse!
    ordered_list.map! do |item|
      item.id
    end

    current_sales = Sale.where("end_date > ?", Date.current)
    current_sales_list = {}
    current_sales.each do |sale|
      sale.packs.each do |pack_id|
        current_sales_list[pack_id] = sale.percentage
      end
    end

    line_items = []
    total_amount = 0
    ordered_list.each_with_index do |item, index|
      pack = SfxPack.find(item)
      line_item = {}
      line_item[:name] = pack.title
      line_item[:images] = [pack.photos[0]]

      if current_sales.count > 0
        if current_sales_list[pack.id]
          line_item[:amount] = (pack.price_cents * (100 - current_sales_list[pack.id]) / 100.to_f).to_i
        else
          line_item[:amount] = pack.price_cents
        end
      else
        if index.positive?
          line_item[:amount] = (pack.price_cents * 0.8).to_i
        else
          line_item[:amount] = pack.price_cents
        end
      end
      line_item[:currency] = 'usd'
      line_item[:quantity] = 1
      line_items << line_item
      total_amount += line_item[:amount] / 100.to_f
    end
    sfx_pack = SfxPack.find(cart.items.first)

    if current_user
      order = Order.create!(product_link: "", sfx_pack: sfx_pack, amount: total_amount, status: 'pending', user: current_user, multiple: multiple, packs: ordered_list, sales: @sale_orders)
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: line_items,
        allow_promotion_codes: true,
        success_url: destroy_cart_url,
        cancel_url: destroy_order_url
      )

      order.update(checkout_session_id: session.id)
      redirect_to new_order_payment_path(order)
    else
      redirect_to(new_user_session_path)
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
    redirect_to new_order_payment_path(@order)
  end

  def destroy
    Order.where(user_id: current_user.id).last.destroy
    redirect_to cart_path
  end

  def destroy_from_dashboard
    # no use at this point
  end

  private

  def sale_orders
    current_sales = Sale.where("end_date > ?", Date.current)
    @sale_orders = {}


    current_sales.each do |sale|
      sale.packs.each do |pack_id|
        @sale_orders[pack_id] = {}
        @sale_orders[pack_id][sale.title] = sale.percentage
      end
    end
  end

  def create_cart(item)
    @cart = Cart.create(user_id: current_user.id)
    @cart.items = []
    @cart.items << item.id.to_i
    @cart.save
  end
end
