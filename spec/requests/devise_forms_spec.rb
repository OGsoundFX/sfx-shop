require 'rails_helper'

RSpec.describe "Devise forms", type: :request do
  describe "sign up" do
    it "renders server-side validation errors for invalid input" do
      post user_registration_path, params: {
        user: {
          email: "invalid-email",
          password: "password123",
          password_confirmation: "password123"
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Sign up")
      expect(response.body).to include("Email is invalid")
    end

    it "disables browser validation and Turbo interception on the form" do
      get new_user_registration_path

      expect(response.body).to include('novalidate="novalidate"')
      expect(response.body).to include('data-turbo="false"')
    end
  end

  describe "log in" do
    it "disables browser validation and Turbo interception on the form" do
      get new_user_session_path

      expect(response.body).to include('novalidate="novalidate"')
      expect(response.body).to include('data-turbo="false"')
    end

    it "returns the server-side invalid-credentials response" do
      post user_session_path, params: {
        user: {
          email: "unknown@example.com",
          password: "wrong-password"
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Log in")
    end
  end
end
