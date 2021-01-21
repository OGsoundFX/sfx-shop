class AdministratorController < ApplicationController
  def admin
    redirect_to root_path if current_user.nil? || current_user.email != 'olivier@ogsoundfx.com'
    @all_sales = Sale.all
    @current_sales = Sale.where("end_date > ?", Date.current)
    @sale = Sale.last
  end
end
