# app/services/stripe_service.rb
class StripeClientService
  attr_reader :api_key

  def initialize(test_mode: false)
    @api_key = test_mode ? ENV['TEST_STRIPE_SECRET_KEY'] : ENV['STRIPE_SECRET_KEY']
  end
end
