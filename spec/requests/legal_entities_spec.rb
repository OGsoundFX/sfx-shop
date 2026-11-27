require 'rails_helper'

RSpec.describe "LegalEntities", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) do
    User.create!(
      email: "legal-entity-user@example.com",
      password: "password123",
      confirmed_at: Time.current
    )
  end

  before { sign_in user }

  describe "POST /legal_entities" do
    let(:invalid_params) do
      {
        legal_entity: {
          first_name: "",
          last_name: "",
          street_name: "",
          street_number: "",
          city: "",
          postal_code: "",
          country: "",
          payment_infos_attributes: {
            "0" => {
              paypal_account: "not-an-email",
              preferred_currency: "usd"
            }
          }
        }
      }
    end

    it "renders validation errors for an HTML request" do
      post legal_entities_path, params: invalid_params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("must be a valid email address")
    end

    it "replaces the form with validation errors for a Turbo request" do
      post legal_entities_path,
           params: invalid_params,
           headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include('target="legal_entity_form"')
      expect(response.body).to include("must be a valid email address")
      expect(response.body).to include("legal_entity[payment_infos_attributes]")
    end
  end
end
