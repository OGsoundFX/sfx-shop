def checkout
  cart = Cart.where(user_id: current_user.id).first
  line_items = []
  total_amount = 0
  cart.items.each do |item|
    pack = SfxPack.find(item)
    line_item = {}
    line_item[:name] = pack.title
    line_item[:images] = [pack.photos[0]]
    line_item[:amount] = pack.price_cents
    line_item[:currency] = 'usd'
    line_item[:quantity] = 1
    line_items << line_item
    total_amount += pack.price
  end
  product_link = 'https://www.ogsoundfx.com/sound-fx-files/27_Free_SFX_by_OG_Sound_FX.zip'
  sfx_pack = SfxPack.find(cart.items.first)

  if current_user
    order = Order.create!(product_link: product_link, sfx_pack: sfx_pack, amount: total_amount, status: 'pending', user: current_user, multiple: true, packs: cart.items)
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
