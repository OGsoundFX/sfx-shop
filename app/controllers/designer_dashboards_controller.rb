class DesignerDashboardsController < ApplicationController
  before_action :unauthorized_redirect, :load_designer
  before_action :load_pack, only: [:update_pack_form, :remove_pack]

  def main
  end

  def stats
    @sold_items = @designer.sold_items.where(status: 'pending').includes(:sfx_pack).joins(:order).where(order: {status: "paid"}).order(created_at: :desc)
    @past_sold_items = @designer.sold_items.where(status: 'paid').includes(:sfx_pack).joins(:order).where(order: {status: "paid"}).order(created_at: :desc)
    @payout_amount = @sold_items.sum(:amount_cents) / 100.0
  end

  def listings
    # @live_packs = @designer.sfx_packs.live.order(updated_at: :desc)
    # @pending_packs = @designer.sfx_packs.pending.order(updated_at: :desc)
    # @under_review_packs = @designer.sfx_packs.under_review.order(updated_at: :desc)
    # @declined_packs = @designer.sfx_packs.declined.order(updated_at: :desc)

    @packs = @designer.sfx_packs.where.not(id: 100).order(:status)
  end

  def pack_form
    @designer = current_user.sound_designer
    @sfx_pack = SfxPack.new
  end

  def update_pack_form
    @designer = current_user.sound_designer
  end

  def remove_pack
    @sfx_pack.removed!
    redirect_to designer_listings_path
  end

  def paypal_account
    @paypal.update(payment_params)
    @paypal.sound_designer = @designer
    @paypal.save
    redirect_to designer_main_dashboard_path, notice: "Paypal account updated"
  end

  def update_designer_info
    @designer.update(designer_params)
    @designer.user.save if @designer.user.changed?
    if @designer.save
      redirect_to designer_main_dashboard_path, notice: "Information updated"
    else
      render :main, status: :unprocessable_entity
    end
  end

  def update_designer_bio
    @designer.update(bio_params)
    if @designer.save
      redirect_to designer_main_dashboard_path, notice: "Bio updated"
    else
      render :main, status: :unprocessable_entity
    end
  end

  private

  def load_designer
    @designer = current_user.sound_designer
    @paypal = @designer.payment_infos.last || @designer.payment_infos.new
  end

  def unauthorized_redirect
    redirect_to root_path, notice: "You need to sign in to access this page" if !user_signed_in?
  end

  def load_pack
    @sfx_pack = SfxPack.find(params[:id])
  end

  def payment_params
    params.require(:payment_info).permit(:paypal_account)
  end

  def designer_params
    params.require(:sound_designer).permit(:first_name, :last_name, :location)
  end

  def bio_params
    params.require(:sound_designer).permit(:bio)
  end
end
