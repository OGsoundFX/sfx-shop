class StripeCheckoutSessionService
  def call(event)
    order = Order.find_by(checkout_session_id: event.data.object.id)
    order.update(status: 'paid')
    order.update(amount_paid_cents: event.data.object.amount_total)
  end
end
