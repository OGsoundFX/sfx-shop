class DashboardsController < ApplicationController
  before_action :authenticate_user!
  def dashboard
    @pending = current_user.orders.where(status: "pending").order(created_at: :desc)
    @orders = current_user.orders.where(status: "paid").order(created_at: :desc)

    audience_id = ENV['MAILCHIMP_LIST_ID']
    begin
      @status = Gibbon::Request.lists(audience_id).members(current_user.email).retrieve.body["status"]
    rescue
      @status = "Not Subscribed"
    end
  end

  def unsubscribe
    audience_id = ENV['MAILCHIMP_LIST_ID']
    gibbon = Gibbon::Request.new
    gibbon.lists(audience_id).members(current_user.email).update(body: { status: "unsubscribed" })
    redirect_to dashboard_path
  end

  def subscribe
    audience_id = ENV['MAILCHIMP_LIST_ID']
    gibbon = Gibbon::Request.new
    gibbon.lists(audience_id).members(current_user.email).update(body: { status: "subscribed" })
    redirect_to dashboard_path
  end
end
