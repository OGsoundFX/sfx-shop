class AdministratorController < ApplicationController
  def admin
    redirect_to root_path if current_user.nil? || current_user.email != 'olivier@ogsoundfx.com'
    @sale = Sale.last
  end
end
