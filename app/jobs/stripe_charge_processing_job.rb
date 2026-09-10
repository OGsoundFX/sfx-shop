class StripeChargeProcessingJob < ApplicationJob
	queue_as :default

	retry_on StandardError, wait: 1.second, attempts: 60

	def perform(payment_intent_id)
		StripeChargeProcessingService.call(payment_intent_id)
	end
end
