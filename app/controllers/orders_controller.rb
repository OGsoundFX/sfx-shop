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
      order = Order.create!(
        location: session[:location],
        product_link: sfx_pack.product_link,
        sfx_pack: sfx_pack, amount: sfx_pack_price,
        amount_paid_currency: CurrencySymbolService.lookup(params[:currency]).upcase,
        status: 'pending',
        user: current_user,
        sales: @sale_orders,
        collections: []
      )

      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        mode: 'payment',
        line_items: [{
          price_data: {
            currency: CurrencySymbolService.lookup(params[:currency]),
            unit_amount: (sfx_pack_price.to_i * 100),
            product_data: {
              name: sfx_pack.title,
              images: [sfx_pack.photos[0].url] # Ensure this returns a full http(s) URL
            }
          },
          quantity: 1
        }],
        metadata: {
          order_id: order.id
        },
        allow_promotion_codes: true,
        customer_email: current_user.email,
        success_url: dashboard_url,
        cancel_url: destroy_order_url
      )

      order.update(checkout_session_id: session.id)

      # creating sold_item instance
      SoldItem.create!(
        sound_designer: current_user.sound_designer,
        sfx_pack_id: sfx_pack.id,
        order: order,
        amount_cents: order.amount,
        currency: order.amount_paid_currency.downcase,
        payout_amount_cents: 0,
        payout_currency: sfx_pack.currency,
        status: 'pending',
        discount: @discount ? true : false,
        discount_type: @discount ? 'sale' : 'none',
        discount_percentage: discount_percentage,
        discount_name: discount_name
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
    ordered_list.map! { it.id }

    current_sales = Sale.where("end_date > ?", Date.current)
    current_sales_list = {}
    current_sales.each do |sale|
      sale.packs.each do |pack_id|
        current_sales_list[pack_id] = sale.percentage
      end
    end

    line_items = []
    pack_line_items = []
    total_amount = 0

    ordered_list.each_with_index do |item_id, index|
      pack = SfxPack.find(item_id)

      # calculating conversion rate
      if pack.currency_symbol != params[:currency]
        conversion_rate = CurrencyRate.where("base = ? AND target = ?", pack.currency.upcase, CurrencySymbolService.lookup(params[:currency]).upcase).order(created_at: :desc).first.rate.to_f
      else
        conversion_rate = 1
      end

      # Calculate final amount based on sales/discounts
      calculated_amount = if current_sales.count > 0 && current_sales_list[pack.id]
                            ((pack.price_cents * conversion_rate) * (100 - current_sales_list[pack.id]) / 100.0).to_i
                          elsif index.positive?
                            ((pack.price_cents * conversion_rate) * 0.8).to_i
                          else
                            (pack.price_cents * conversion_rate).to_i
                          end
      # Ensure image is a URL string, not an ActiveStorage object
      image_url = pack.photos.attached? ? pack.photos[0].url : nil

      # Construct the NEW Stripe line_item structure
      product_data = { name: pack.title }
      product_data[:images] = [image_url] if image_url.present?

      line_item = {
        price_data: {
          currency: CurrencySymbolService.lookup(params[:currency]),
          unit_amount: calculated_amount,
          product_data: product_data
        },
        quantity: 1
      }

      line_items << line_item
      pack_line_items << { pack: pack, amount_cents: calculated_amount }
      total_amount += (calculated_amount / 100.0)
    end

    # Fallback for order creation if cart is empty
    sfx_pack = cart.items.present? ? SfxPack.find(cart.items.first) : SfxPack.find(100)

    # List Single Tracks
    tracks_list = cart.sinlge_tracks.map { SingleTrack.find(it) }

    # Calculating conversion rate for single tracks
    single_tracks_conversion_rate = ("$" != params[:currency]) ? CurrencyRate.where("base = ? AND target = ?", "USD", "EUR").order(created_at: :desc).first.rate.to_f : 1

    # Total amount of Single Tracks
    tracks_sum = tracks_list.sum { (it.price_cents * single_tracks_conversion_rate) / 100.to_f }

    # creating line_item for single tracks as one track if any
    if tracks_list.present?
      single_line_item = {
        price_data: {
          currency: CurrencySymbolService.lookup(params[:currency]),
          unit_amount: (tracks_sum * 100).to_i,
          product_data: {
            name: 'Individual tracks'
          }
        },
        quantity: 1
      }
      line_items << single_line_item
    end

    # Adding collection to order
    collection_sum = 0
    collection = []

    if params[:collection_id]
      conversion_rate = ("$" != params[:currency]) ? CurrencyRate.where("base = ? AND target = ?", "USD", "EUR").order(created_at: :desc).first.rate.to_f : 1
      collection << params[:collection_id].to_i
      collection_sum = ((Collection.find(params[:collection_id]).price_cents * conversion_rate) / 100.to_f)

      collection_line_item = {
        price_data: {
          currency: CurrencySymbolService.lookup(params[:currency]),
          unit_amount: (collection_sum * 100).to_i,
          product_data: {
            name: 'Collection'
          }
        },
        quantity: 1
      }
      line_items << collection_line_item
    end

    # Adding sum of SFX packs, single tracks & collection for the order
    total_amount += tracks_sum += collection_sum

    if current_user
      cart.with_lock do
        existing_order = current_user.orders
          .where(id: session[:pending_checkout_order_id], status: "pending")
          .where(packs: ordered_list, tracks: cart.sinlge_tracks, collections: collection)
          .where.not(checkout_session_id: nil)
          .first

        if existing_order
          return redirect_to new_order_payment_path(existing_order)
        end

        # creating order instance
        order = Order.create!(
        location: session[:location],
        product_link: "",
        sfx_pack: sfx_pack,
        amount: total_amount,
        amount_paid_currency: CurrencySymbolService.lookup(params[:currency]).upcase,
        status: 'pending',
        user: current_user,
        multiple: multiple,
        packs: ordered_list,
        tracks: cart.sinlge_tracks,
        sales: @sale_orders,
        collections: collection
        )
        session[:pending_checkout_order_id] = order.id

        session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        mode: 'payment',
        line_items: line_items,
        metadata: {
          order_id: order.id
        },
        allow_promotion_codes: true,
        customer_email: current_user.email,
        success_url: destroy_cart_url,
        cancel_url: destroy_order_url,
        )
        order.update!(checkout_session_id: session.id)

        # checking sales
        current_sales = Sale.where("end_date > ?", Date.current)

        # creating sold_item instances
        pack_line_items.each_with_index do |pack_line_item, index|
          pack = pack_line_item[:pack]

          # Determine discount logic
          @discount = false
          current_sales.each do |sale|
            if sale.packs.include?(pack.id)
              @discount = sale.percentage
              break
            end
          end

          if @discount
            discount = true
            discount_type = 'sale'
            discount_percentage = order.sales.first[1].values.first if order.sales.first&.[](1)
            discount_name = order.sales.first[1].keys.first if order.sales.first&.[](1)
          elsif index > 0
            discount = true
            discount_type = 'additional'
            discount_percentage = 20
            discount_name = "Multiple Purchase"
          else
            discount = false
            discount_type = 'no_discount'
            discount_percentage = 0
            discount_name = nil
          end

          SoldItem.create!(
            sound_designer: pack.sound_designer,
            order: order,
            sfx_pack: pack,
            amount_cents: pack_line_item[:amount_cents],
            currency: order.amount_paid_currency.downcase,
            payout_amount_cents: 0,
            payout_currency: pack.currency,
            status: 'pending',
            discount: discount,
            discount_type: discount_type,
            discount_percentage: discount_percentage || 0,
            discount_name: discount_name
          )
        end

        redirect_to new_order_payment_path(order)
      end
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
    session.delete(:pending_checkout_order_id)
    redirect_to cart_path
  end

  # def update_order_status
  #   order = current_user.orders.last
  #   order.update(
  #     status: "paid",
  #     amount_paid_cents: order.amount_cents
  #   )
  #   redirect_to dashboard_path
  # end

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

  def check_sales
  end

  def create_cart(item)
    @cart = Cart.create(user_id: current_user.id)
    @cart.items = []
    @cart.items << item.id.to_i
    @cart.save
  end
end
