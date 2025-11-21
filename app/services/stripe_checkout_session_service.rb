class StripeCheckoutSessionService
  def call(event)
    # Rails.logger.info "=== STRIPE EVENT ==="
    # Rails.logger.info JSON.pretty_generate(event.to_h)

    case event.type
    when 'checkout.session.completed'
      session = event.data.object
      order = Order.find_by(checkout_session_id: session.id)
      order.status = "paid"
      order.payment_intent_id = session.payment_intent
      order.save
    when 'charge.succeeded'
      charge = event.data.object
      balance_tx_id = charge.balance_transaction

      # Retrieve balance transaction to get fees and net
      balance_tx = Stripe::BalanceTransaction.retrieve(balance_tx_id)
      total_fees = balance_tx.fee

      order = Order.find_by(payment_intent_id: charge.payment_intent)
      order.sold_items.each do |item|
        # spread the stripe fees equally to all packs
        # if payment currency != euros make sure conversion is taken in account
        if order.amount_paid_currency != "EUR"
          # recalculating fees in the initial payment currency, because stripe automatically converts them in euros
           fees = ((total_fees/ balance_tx.exchange_rate.to_f) / order.amount_cents) * item.amount_cents
        else
          fees = (total_fees / order.amount_cents.to_f) * item.amount_cents
        end
        # calculating payout amount after VAT, fees and 70% share applied
        if item.payout_currency != item.currency
          # fetch exchange rate:
          exchange_rate = CurrencyRate.where(base: item.payout_currency.upcase).order(created_at: :desc).first.rate.to_f
          payout_amount = ((item.amount_cents * 0.9344) - fees) * 0.7
          item.payout_amount_cents = payout_amount / exchange_rate
          item.stripe_fees_cents = fees / exchange_rate
        else
          payout_amount = ((item.amount_cents * 0.9344) - fees) * 0.7
          item.payout_amount_cents = payout_amount
          item.stripe_fees_cents = fees
        end
        item.save
      end
    when 'payment_intent.succeeded'
    else
      Rails.logger.info "Unhandled Stripe event: #{event.type}"
    end
  end
end
