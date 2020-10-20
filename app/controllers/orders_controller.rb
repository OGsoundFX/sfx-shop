class OrdersController < ApplicationController
  def create
    product_link = 'https://www.ogsoundfx.com/sound-fx-files/27_Free_SFX_by_OG_Sound_FX.zip'
    sfx_pack = SfxPack.find(params[:pack_id])
    @photo = sfx_pack.photos[0]
    # if statment to create an account or login to purchase
    if current_user
      # check about all the fields of the Order
      if Cart.where(user_id: current_user.id).count == 1
        cart = Cart.where(user_id: current_user.id).first
        cart.items << sfx_pack.id.to_i
        cart.save
      else
        create_cart(sfx_pack)
      end

      order = Order.create!(product_link: product_link, sfx_pack: sfx_pack, amount: sfx_pack.price, discount_id: 1, status: 'pending', user: current_user)
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: sfx_pack.title,
          images: [sfx_pack.photos[0]],
          amount: sfx_pack.price_cents,
          currency: 'usd',
          quantity: 1
        }],
        allow_promotion_codes: true,
        success_url: dashboard_url,
        cancel_url: cart_url
      )

      order.update(checkout_session_id: session.id)
      redirect_to new_order_payment_path(order)
    else
      redirect_to(new_user_session_path)
    end
  end

  def checkout
    cart = Cart.where(user_id: current_user.id).first
    line_items = []
    cart.items.each do |item|
      pack = SfxPack.find(item)
      line_item = {}
      line_item[:name] = pack.title
      line_item[:images] = [pack.photos[0]]
      line_item[:amount] = pack.price_cents
      line_item[:currency] = 'usd'
      line_item[:quantity] = 1
      line_items << line_item
    end

    product_link = 'https://www.ogsoundfx.com/sound-fx-files/27_Free_SFX_by_OG_Sound_FX.zip'
    sfx_pack = SfxPack.find(cart.items.first)
    # if statment to create an account or login to purchase
    if current_user

      order = Order.create!(product_link: product_link, sfx_pack: sfx_pack, amount: sfx_pack.price, discount_id: 1, status: 'pending', user: current_user)
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: line_items,
        allow_promotion_codes: true,
        success_url: dashboard_url,
        cancel_url: cart_url
      )

      order.update(checkout_session_id: session.id)
      redirect_to new_order_payment_path(order)
    else
      redirect_to(new_user_session_path)
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  private

  def create_cart(item)
    @cart = Cart.create(user_id: current_user.id)
    @cart.items = []
    @cart.items << item.id.to_i
    @cart.save
  end
end
