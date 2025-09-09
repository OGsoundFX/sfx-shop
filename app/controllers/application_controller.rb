class ApplicationController < ActionController::Base
  before_action :set_currency
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :store_location

  # def store_location
  #   if (request.path != "/users/sign_in" &&
  #     request.path != "/users/sign_up" &&
  #     request.path != "/users/password/new" &&
  #     request.path != "/users/password/edit" &&
  #     request.path != "/users/confirmation" &&
  #     request.path != "/users/sign_out" &&
  #     !request.xhr? && !current_user) # don't store ajax calls
  #     session[:previous_url] = request.fullpath
  #   end
  # end

  def after_sign_in_path_for(resource)
    params[:url] || root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :username, :location, :subscribe) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :username, :location, :current_password) }
  end

  def set_currency
    location = Geocoder.search(request.remote_ip).first
    country = location&.country_code
    eurozone_countries = %w[AT BE CY EE FI FR DE GR IE IT LV LT LU MT NL PT SK SI ES]
    session[:currency] = eurozone_countries.include?(country) ? '€' : '$'

    # for testing locally
    # session[:currency] = '$'
  end
end
