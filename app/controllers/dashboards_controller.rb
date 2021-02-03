class DashboardsController < ApplicationController
  before_action :authenticate_user!
  def dashboard
    @pending = current_user.orders.where(status: "pending").order(created_at: :desc)
    @orders = current_user.orders.where(status: "paid").order(created_at: :desc)

    user_email = current_user.email
    audience_id = ENV['MAILCHIMP_LIST_ID']
    begin
      @status = Gibbon::Request.lists(audience_id).members(user_email).retrieve.body["status"]
    rescue
      @status = "Not Subscribed"
    end
  end
end
