class OrdersController < ApplicationController
  before_action :sale_orders, only: [:create, :checkout]

  # action to purchase pack directly
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
      order = Order.create!(product_link: sfx_pack.product_link, sfx_pack: sfx_pack, amount: sfx_pack_price, status: 'pending', user: current_user, sales: @sale_orders, collections: [])
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: sfx_pack.title,
          images: [sfx_pack.photos[0]],
          amount: (sfx_pack_price.to_i * 100),
          currency: CurrencySymbolService.lookup(params[:currency]),
          quantity: 1,
          tax_rates: [ENV['STRIPE_TAX_RATE']]
        }],
        allow_promotion_codes: true,
        success_url: update_order_status_url,
        cancel_url: destroy_order_url
      )

      order.update(checkout_session_id: session.id)

      # creating sold_item instance
      SoldItem.create!(
        sound_designer: current_user.sound_designer,
        order: order,
        amount: order.amount,
        status: 'pending',
        discount: @discount ? true : false,
        discount_type: @discount ? 'sale' : 'none'
      )

      redirect_to new_order_payment_path(order)
    else
      redirect_to(new_user_session_path)
    end
  end

  # checkout from Cart
  def checkout
    # cart = Cart.where(user_id: current_user.id).first
    cart = Cart.find(params[:cart_id])

    cart.items.count == 1 ? multiple = false : multiple = true

    # list SFX packs
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

      # calculating conversion rate
      if pack.currency_symbol != params[:currency]
        conversion_rate = CurrencyRate.where("base = ? AND target = ?", pack.currency.upcase, "USD").order(created_at: :desc).first.rate.to_f
      else
        conversion_rate = 1
      end

      line_item = {}
      line_item[:name] = pack.title
      line_item[:images] = [pack.photos[0]]

      if current_sales.count > 0
        if current_sales_list[pack.id]
          line_item[:amount] = ((pack.price_cents * conversion_rate) * (100 - current_sales_list[pack.id]) / 100.to_f).to_i
        else
          line_item[:amount] = (pack.price_cents * conversion_rate).to_i
        end
      else
        if index.positive?
          line_item[:amount] = ((pack.price_cents * conversion_rate) * 0.8).to_i
        else
          line_item[:amount] = (pack.price_cents * conversion_rate).to_i
        end
      end
      line_item[:currency] = CurrencySymbolService.lookup(params[:currency])
      line_item[:quantity] = 1
      line_items << line_item
      total_amount += (line_item[:amount] / 100.to_f)
    end

    if cart.items != []
      sfx_pack = SfxPack.find(cart.items.first)
    else
      sfx_pack = SfxPack.find(100)
    end

    # List Single Tracks
    tracks_list = []
    cart.sinlge_tracks.each do |track|
      tracks_list << SingleTrack.find(track)
    end

    # Calculating conversion rate for single tracks
    if "$" != params[:currency]
      single_tracks_conversion_rate = CurrencyRate.where("base = ? AND target = ?", "USD", "EUR").order(created_at: :desc).first.rate.to_f
    else
      single_tracks_conversion_rate = 1
    end

    # Total amount of Single Tracks
    tracks_sum = 0
    tracks_list.each do |track|
      tracks_sum += ((track.price_cents * single_tracks_conversion_rate) / 100.to_f)
    end

    # creating line_item for single tracks as one track if any
    if tracks_list != []
      single_line_item = {}
      single_line_item[:name] = 'Individual tracks'
      # single_line_item[:image]
      single_line_item[:amount] = (tracks_sum * 100).to_i
      single_line_item[:currency] = CurrencySymbolService.lookup(params[:currency])
      single_line_item[:quantity] = 1
      line_items << single_line_item
    end

    # Adding collection to order
    if params[:collection_id]
      if "$" != params[:currency]
        conversion_rate = CurrencyRate.where("base = ? AND target = ?", "USD", "EUR").order(created_at: :desc).first.rate.to_f
      else
        conversion_rate = 1
      end
      collection = []
      collection << params[:collection_id].to_i
      collection_sum = ((Collection.find(params[:collection_id]).price_cents * conversion_rate) / 100.to_f)

      # creating line_item for collection
      collection_line_item = {}
      collection_line_item[:name] = 'Collection'
      collection_line_item[:amount] = (collection_sum * 100).to_i
      collection_line_item[:currency] = CurrencySymbolService.lookup(params[:currency])
      collection_line_item[:quantity] = 1
      line_items << collection_line_item
    else
      collection = []
      collection_sum = 0
    end

    # Adding sum of SFX packs, single tracks & collection for the order
    total_amount += tracks_sum += collection_sum

    if current_user
      # adding the 7% of taxe on all items
      line_items.each do |item|
        item[:tax_rates] =  [ENV['STRIPE_TAX_RATE']]
      end
      # creating order instance
      order = Order.create!(product_link: "", sfx_pack: sfx_pack, amount: total_amount, status: 'pending', user: current_user, multiple: multiple, packs: ordered_list, tracks: cart.sinlge_tracks, sales: @sale_orders, collections: collection)
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: line_items,
        allow_promotion_codes: true,
        success_url: destroy_cart_url,
        cancel_url: destroy_order_url,
      )

      order.update(checkout_session_id: session.id)

      # creating sold_item instance
      raise
      SoldItem.create!(
        sound_designer: current_user.sound_designer,
        order: order,
        amount: order.amount,
        status: 'pending',
        discount: @discount ? true : false,
        discount_type: @discount ? 'sale' : 'none'
      )

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

  def update_order_status
    order = current_user.orders.last
    order.update(status: "paid")
    order.update(amount_paid_cents: order.amount_cents)
    redirect_to dashboard_path
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
