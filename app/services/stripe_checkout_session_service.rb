class StripeCheckoutSessionService
  def call(event)
    # Rails.logger.info "=== STRIPE EVENT ==="
    # Rails.logger.info JSON.pretty_generate(event.to_h)

    case event.type
    when 'checkout.session.completed'
      session = event.data.object
      order = Order.find_by(checkout_session_id: session.id)
      order.status = "paid"
      order.amount_paid_cents = order.amount_cents
      order.payment_intent_id = session.payment_intent
      order.save!
      StripeChargeProcessingJob.perform_later(session.payment_intent)
    when 'charge.succeeded'
      charge = event.data.object
      StripeChargeProcessingJob.perform_later(charge.payment_intent)
    end
  end
end
