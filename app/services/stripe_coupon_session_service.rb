class StripeCouponSessionService
  def call(event)
    order = Order.find_by(checkout_session_id: event.data.object.checkout_session)
    coupon_name = event.data.object.coupon.name
    if event.data.object.coupon.percent_off
      coupon_type = 'Percentage'
      coupon_value = event.data.object.coupon.percent_off
    else
      coupon_type = 'Amount'
      coupon_value = event.data.object.coupon.amount_off
    end
    coupon = "#{coupon_name}, #{coupon_type}, #{coupon_value}"
    order.update(coupon: coupon)
  end
end
