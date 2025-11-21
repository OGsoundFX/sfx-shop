# config/initializers/stripe.rb
Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key:      ENV['STRIPE_SECRET_KEY'],
  signing_secret:  ENV['STRIPE_WEBHOOK_SECRET_KEY'],
  tax_rate:        ENV['STRIPE_TAX_RATE']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.subscribe 'checkout.session.completed' do |event|
    StripeCheckoutSessionService.new.call(event)
  end
  events.subscribe 'charge.succeeded' do |event|
    StripeCheckoutSessionService.new.call(event)
  end
end


# StripeEvent.configure do |events|
#   events.subscribe 'checkout.session.completed', StripeCheckoutSessionService.new
#   events.subscribe 'customer.discount.created', StripeCouponSessionService.new
# end
