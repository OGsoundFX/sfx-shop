class PayoutsController < ApplicationController
  def new
    @designer = SoundDesigner.find(params[:sound_designer_id])
    @payout = Payout.new
  end

  def create
    raise
  end

  private

  def payout_params
    params.require(:payout).permit(:payout_date)
  end
end
