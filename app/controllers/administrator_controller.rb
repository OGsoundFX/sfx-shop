class AdministratorController < ApplicationController
  def admin
    redirect_to root_path if current_user.email != 'olivier@ogsoundfx.com'
  end
end
