class PaymentInfosController < ApplicationController
  def create
  end

  private

  def payment_info_params
    params.require(:payment_info).permit(:paypal_account, :preferred_currency)
  end
end
