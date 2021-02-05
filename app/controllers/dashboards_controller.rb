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

  # def subscribe
  #   audience_id = ENV['MAILCHIMP_LIST_ID']
  #   gibbon = Gibbon::Request.new
  #   gibbon.lists(audience_id).members(current_user.email).update(body: { status: "subscribed" })
  #   redirect_to dashboard_path
  # end

  def subscribe
    gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    user = current_user
    audience_id = ENV['MAILCHIMP_LIST_ID']

    begin
      Gibbon::Request.lists(audience_id).members(user.email).retrieve.nil?
      gibbon.lists(audience_id).members(current_user.email).update(body: { status: "subscribed" })
      redirect_to dashboard_path
    rescue
      gibbon.lists(audience_id).members.create(
        body: {
          email_address: user.email,
          status: "subscribed",
          merge_fields: {
            FNAME: user.username,
            # LNAME: @user.last_name
          }
        }
      )
      redirect_to dashboard_path
    end
  end
end
