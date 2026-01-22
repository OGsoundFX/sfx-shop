class LegalEntitiesController < ApplicationController

  def new
    redirect_to edit_legal_entity_path(current_user.legal_entity) if current_user.legal_entity.present?
    redirect_to new_sound_designer_path if !current_user.sound_designer.present?
    @legal_entity = LegalEntity.new
    @payment_info = @legal_entity.payment_infos.build
  end

  def create
    @legal_entity = LegalEntity.new(legal_entity_params)
    @legal_entity.user = current_user
    @legal_entity.pending!
    if @legal_entity.save
      DesignerMailer.submission_completed(@legal_entity).deliver_later
      redirect_to designer_listings_path, notice: "Legal entity created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @legal_entity = LegalEntity.find(params[:id])
    redirect_to settings_path
  end

  def update
    @legal_entity = LegalEntity.find(params[:id])
    if @legal_entity.update(legal_entity_params)
      @legal_entity.pending!
      redirect_to settings_path, notice: "Legal entity updated successfully. Waiting Approval."
    else
      render "designer_dashboards/settings", status: :unprocessable_entity
    end
  end

  private

  def legal_entity_params
    params.require(:legal_entity).permit(:first_name, :last_name, :company_name, :street_name, :street_number, :address_line_2, :city, :postal_code, :country, :state, payment_infos_attributes: [:paypal_account, :preferred_currency, :_destroy])
  end
end
