class StripeCheckoutSessionService
  def call(event, enqueue_charge_processing: true, admin_orders_only: false)
    # Rails.logger.info "=== STRIPE EVENT ==="
    # Rails.logger.info JSON.pretty_generate(event.to_h)

    case event.type
    when 'checkout.session.completed'
      session = event.data.object
      order = Order.find_by(checkout_session_id: session.id)
      unless order
        Rails.logger.warn("No order found for Stripe checkout session #{session.id}")
        return
      end
      if admin_orders_only && !order.user.admin?
        Rails.logger.warn("Ignoring test checkout session for non-admin order #{order.id}")
        return
      end

      order.update!(
        status: "paid",
        amount_paid_cents: order.amount_cents,
        payment_intent_id: session.payment_intent
      )
      StripeChargeProcessingJob.perform_later(session.payment_intent) if enqueue_charge_processing
    when 'charge.succeeded'
      charge = event.data.object
      StripeChargeProcessingJob.perform_later(charge.payment_intent) if enqueue_charge_processing
    end
  end
end
