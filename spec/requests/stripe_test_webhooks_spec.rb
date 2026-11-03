require 'rails_helper'

RSpec.describe "StripeTestWebhooks", type: :request do
  describe "POST /stripe-webhooks/test" do
    let(:admin) { double(admin?: true) }
    let(:order) { double(id: 1, user: admin, amount_cents: 1500) }
    let(:checkout_session) do
      double(id: "cs_test_123", payment_intent: "pi_test_123")
    end
    let(:event) do
      double(
        livemode: false,
        type: "checkout.session.completed",
        data: double(object: checkout_session)
      )
    end

    before do
      allow(Stripe::Webhook).to receive(:construct_event).and_return(event)
      allow(Order).to receive(:find_by)
        .with(checkout_session_id: "cs_test_123")
        .and_return(order)
    end

    it "marks a matching admin order paid without queuing live charge processing" do
      expect(order).to receive(:update!).with(
        status: "paid",
        amount_paid_cents: 1500,
        payment_intent_id: "pi_test_123"
      )
      expect(StripeChargeProcessingJob).not_to receive(:perform_later)

      post "/stripe-webhooks/test",
           params: "{}",
           headers: { "Stripe-Signature" => "valid-signature" }

      expect(response).to have_http_status(:ok)
    end

    it "does not mark a non-admin order paid" do
      allow(order).to receive(:user).and_return(double(admin?: false))
      expect(order).not_to receive(:update!)

      post "/stripe-webhooks/test",
           params: "{}",
           headers: { "Stripe-Signature" => "valid-signature" }

      expect(response).to have_http_status(:ok)
    end

    it "rejects live-mode events" do
      allow(event).to receive(:livemode).and_return(true)
      expect(Order).not_to receive(:find_by)

      post "/stripe-webhooks/test",
           params: "{}",
           headers: { "Stripe-Signature" => "valid-signature" }

      expect(response).to have_http_status(:bad_request)
    end
  end
end
