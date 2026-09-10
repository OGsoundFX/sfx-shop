class StripeChargeProcessingService
	def self.call(payment_intent_id)
		new.call(payment_intent_id)
	end

	def call(payment_intent_id)
		charge = Stripe::Charge.list(payment_intent: payment_intent_id, limit: 1).data.first
		raise "Charge not available for payment intent #{payment_intent_id}" unless charge

		charge = Stripe::Charge.retrieve(id: charge.id, expand: ["balance_transaction"])
		balance_transaction = charge.balance_transaction
		balance_transaction = Stripe::BalanceTransaction.retrieve(balance_transaction) if balance_transaction.is_a?(String)
		balance_transaction ||= Stripe::BalanceTransaction.list(source: charge.id, limit: 1).data.first
		raise "Balance transaction not available for charge #{charge.id}" unless balance_transaction

		order = Order.find_by(payment_intent_id: payment_intent_id)
		raise "Order not available for payment intent #{payment_intent_id}" unless order

		order.sold_items.each do |item|
			should_notify = false

			item.with_lock do
				next if item.payout_processed_at.present?

				fees = if order.amount_paid_currency != "EUR"
							 ((balance_transaction.fee / balance_transaction.exchange_rate.to_f) / order.amount_cents) * item.amount_cents
						 else
							 (balance_transaction.fee / order.amount_cents.to_f) * item.amount_cents
						 end

				payout_amount = PayoutCalculatorService.call(item.amount_cents, order.location)
				if item.payout_currency != item.currency
					exchange_rate = CurrencyRate.where(base: item.payout_currency.upcase).order(created_at: :desc).first.rate.to_f
					item.payout_amount_cents = payout_amount / exchange_rate
					item.stripe_fees_cents = fees / exchange_rate
				else
					item.payout_amount_cents = payout_amount
					item.stripe_fees_cents = fees
				end

				item.payout_processed_at = Time.current
				item.save!
				should_notify = true
			end

			DesignerMailer.you_made_a_sale(item).deliver_later if should_notify
		end
	end
end
