require 'rails_helper'

RSpec.describe "SoundDesigners", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "POST /sound_designers" do
    let(:user) do
      User.create!(
        email: "designer@example.com",
        password: "password123",
        confirmed_at: Time.current,
        designer: true
      )
    end

    before { sign_in user }

    let(:invalid_params) do
      {
        sound_designer: {
          artist_name: "",
          bio: "",
          location: ""
        }
      }
    end

    it "renders the form with validation errors for an HTML request" do
      post sound_designers_path, params: {
        sound_designer: invalid_params[:sound_designer]
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Artist name")
      expect(response.body).to include("minimum is 20 characters")
    end

    it "replaces the form with validation errors for a Turbo request" do
      post sound_designers_path,
           params: invalid_params,
           headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include('target="sound_designer_form"')
      expect(response.body).to include("minimum is 20 characters")
    end
  end
end
