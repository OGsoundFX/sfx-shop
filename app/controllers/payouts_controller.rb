class PayoutsController < ApplicationController
  def new
    @designer = SoundDesigner.find(params[:payout][:designer])
    @payout_info = params[:payout][:paypal_account]
    @sold_items = params[:sold_items].map { |item| GlobalID.find(item)}
  end

  def create
    raise
  end

  private

  def payout_params
    params.require(:payout).permit(:payout_date)
  end
end
