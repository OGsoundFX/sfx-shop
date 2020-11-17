class AdministratorController < ApplicationController
  def admin
    if current_user && current_user.email == 'olivier@ogsoundfx.com'
      redirect to admin_path
    else
      redirect_to root_path
    end
  end
end
