class PayoutsController < ApplicationController
  def new
    @designer = SoundDesigner.find(params[:payout][:designer])
    @payout_info = params[:payout][:paypal_account]
    @sold_items = params[:sold_items].map { |item| GlobalID.find(item)}
    @payout = Payout.new
  end

  def create
    designer = SoundDesigner.find(params[:payout][:designer_id])
    currency = designer.user.legal_entity.payment_infos.last.preferred_currency
    paypal_account = designer.user.legal_entity.payment_infos.last.paypal_account
    sold_items = SoldItem.where(id: params[:sold_item_ids])
    amount_paid = sold_items.sum(&:payout_amount_cents)

    payout = Payout.create(
      sound_designer: designer,
      status: "paid",
      payout_date: Date.today,
      currency: currency,
      amount_cents: amount_paid,
      paypal_account: paypal_account
    )
    sold_items.each(&:paid!)
    sold_items.each do |item|
      item.payout = payout
      item.save
    end

    redirect_to admin_payouts_path
  end

  private

  def payout_params
    params.require(:payout).permit(:payout_date)
  end
end
