class StripeTestWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_currency

  def receive
    event = Stripe::Webhook.construct_event(
      request.raw_post,
      request.headers["Stripe-Signature"],
      Rails.configuration.stripe.fetch(:test_signing_secret)
    )

    return head :bad_request if event.livemode

    # Handle test events separately; don't mark real orders paid or trigger payouts.
    Rails.logger.info("Received verified Stripe test event: #{event.type}")
    head :ok
  rescue JSON::ParserError, Stripe::SignatureVerificationError
    head :bad_request
  end
end
