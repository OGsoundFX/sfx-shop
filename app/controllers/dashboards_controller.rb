class DashboardsController < ApplicationController
  before_action :authenticate_user!
  def dashboard
    @pending = current_user.orders.where(status: "pending").order(created_at: :desc)
    @orders = current_user.orders.where(status: "paid").order(created_at: :desc)
  end
end
