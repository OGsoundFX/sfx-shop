class OrdersController < ApplicationController
  def create
    # Add sku to sfx pack table (sku: sfx_pack.sku)
    # discount = Discount.find(params[coupon: coupon]) || default_discount
    default_discount = Discount.create(kind: 'amount', value: 0)
    product_link = 'https://www.ogsoundfx.com/sound-fx-files/27_Free_SFX_by_OG_Sound_FX.zip'
    sfx_pack = SfxPack.find(params[:pack_id])
    @photo = sfx_pack.photos[0]
    # if statment to create an account or login to purchase
    if current_user
      # check about all the fields of the Order
      order = Order.create!(product_link: product_link, sfx_pack: sfx_pack, amount: sfx_pack.price, status: 'pending', discount: default_discount, user: current_user)

      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: sfx_pack.title,
          # name: sfx_pack.sku,
          images: [sfx_pack.photos[0]],
          amount: sfx_pack.price_cents,
          currency: 'usd',
          quantity: 1
        }],
        success_url: order_url(order),
        cancel_url: order_url(order)
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
end
