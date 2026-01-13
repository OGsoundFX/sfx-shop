class DesignerDashboardsController < ApplicationController
  before_action :unauthenticated_redirect, :new_designer, :check_legal_entity, :load_designer, :agreement_signed
  before_action :load_pack, only: [:update_pack_form, :remove_pack]

  def main
  end

  def listings
    # @live_packs = @designer.sfx_packs.live.order(updated_at: :desc)
    # @pending_packs = @designer.sfx_packs.pending.order(updated_at: :desc)
    # @under_review_packs = @designer.sfx_packs.under_review.order(updated_at: :desc)
    # @declined_packs = @designer.sfx_packs.declined.order(updated_at: :desc)

    @packs = @designer.sfx_packs.where.not(id: 100).order(:status)
  end

  def sales
    @sold_items = @designer.sold_items.where(status: 'pending').includes(:sfx_pack).joins(:order).where(order: {status: "paid"}).order(created_at: :desc)
    @past_sold_items = @designer.sold_items.where(status: 'paid').includes(:sfx_pack).joins(:order).where(order: {status: "paid"}).order(created_at: :desc)
    @payout_amount = @sold_items.sum { |payout| payout.payout_amount_cents if payout.status != "paid"} / 100.0
    @currency_symbol = CurrencySymbolService.lookup(@designer.user.legal_entity.payment_infos.last.preferred_currency)
    @start_date = @sold_items.first.order.created_at.to_date.beginning_of_month.to_s if @sold_items.present?
    @end_date = Date.today.to_s
    if params[:filters].present? && params[:filters][:range_date].present?
      @start_date = params[:filters][:range_date].split("to").first.strip
      @end_date = params[:filters][:range_date].split("to").last.strip
      @sold_items = @sold_items.select do |item|
        item.order.created_at.to_date >= @start_date.to_date && item.order.created_at.to_date <= @end_date.to_date
      end
      @past_sold_items = @past_sold_items.select do |item|
        item.order.created_at.to_date >= @start_date.to_date && item.order.created_at.to_date <= @end_date.to_date
      end
    end
  end

  def payouts
    @sold_items = @designer.sold_items.where(status: 'pending').includes(:sfx_pack).joins(:order).where(order: {status: "paid"}).order(created_at: :desc)
    @payout_amount = @sold_items.sum { |payout| payout.payout_amount_cents if payout.status != "paid"} / 100.0
    @payouts = Payout.where(legal_entity: @designer.legal_entity, status: "paid").order(payout_date: :desc)
    @year = Date.today.year
    @currency_symbol = CurrencySymbolService.lookup(@designer.user.legal_entity.payment_infos.last.preferred_currency)
    if @payouts.present?
      @prior_year_payments = @payouts.first.payout_date.year != @payouts.last.payout_date.year
      @first_payout_year = @payouts.last.payout_date.year
      if params[:filters].present? && params[:filters][:year].present?
        @payouts = @payouts.select { |payout| payout.payout_date.year == params[:filters][:year].to_i }
        @year = params[:filters][:year].to_i
      else
        @payouts = @payouts.select { |payout| payout.payout_date.year == Date.today.year }
      end
    end
  end

  def settings
    @legal_entity = current_user.legal_entity
  end

  def pack_form
    @designer = current_user.sound_designer
    @sfx_pack = SfxPack.new
  end

  def update_pack_form
    @designer = @sfx_pack.sound_designer
    redirect_to designer_listings_path, notice: "You do not have authorisation to access this page" if current_user != @designer.user && !current_user.admin?
  end

  def remove_pack
    @sfx_pack.removed!
    redirect_to designer_listings_path
  end

  def paypal_account
    @paypal.update(payment_params)
    raise
    # ! this is where we need to re-organise everything
    @paypal.user = @designer.user
    @paypal.preferred_currency = params[:payment_info][:preferred_currency].downcase
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

  def update_designer_photo
    if @designer.update(photo_params)
      redirect_to designer_main_dashboard_path, notice: "Photo updated"
    else
      render :main, status: :unprocessable_entity
    end
  end

  def banner
    @designer.banner.purge if @designer.banner.present?
    @designer.banner.attach(params[:sound_designer][:banner])
    if @designer.save
      redirect_to designer_main_dashboard_path, notice: "Banner updated"
    else
      render :main, status: :unprocessable_entity
    end
  end

  private

  def check_legal_entity
    unless current_user.admin?
      if !current_user.legal_entity.present?
        redirect_to new_legal_entity_path
      elsif current_user.legal_entity.incomplete?
        redirect_to edit_legal_entity_path
      elsif !current_user.designer && !current_user.sound_designer.present?
        redirect_to root_path, notice: "You need a seller account to access this page!"
      end
    end
  end

  def load_designer
    if current_user.admin
      @designer = SoundDesigner.find(params[:designer_id])
    else
      @designer = current_user.sound_designer
      if @designer.user.legal_entity.nil?
        redirect_to new_legal_entity_path
      else
        @paypal = @designer.user.legal_entity.payment_infos.last || @designer.user.legal_entity.payment_infos.new
      end
    end
  end

  def unauthenticated_redirect
    redirect_to root_path, notice: "You need to sign in to access this page" if !user_signed_in?
  end

  def new_designer
    redirect_to new_sound_designer_path if user_signed_in? && current_user.designer && current_user.sound_designer.nil?
  end

  def load_pack
    @sfx_pack = SfxPack.find(params[:id])
  end

  def payment_params
    params.require(:payment_info).permit(:paypal_account)
  end

  def designer_params
    params.require(:sound_designer).permit(:artist_name, :location)
  end

  def bio_params
    params.require(:sound_designer).permit(:bio)
  end

  def photo_params
    params.require(:sound_designer).permit(:photo)
  end

  def agreement_signed
    @agreement_signed = @designer.user.legal_entity.agreement_acceptances.where(agreement: Agreement.where(active: true)).exists?

    # this shows the agreement template. we nee to generate the custom agreement for the designer
    @agreement_acceptance = @designer.user.legal_entity.agreement_acceptances.where(agreement: Agreement.where(active: true)).last if @agreement_signed
    @agreement = Agreement.find(@agreement_acceptance.agreement_id) if @agreement_acceptance
  end
end
