class AgreementsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :allow_access, only: :seller_agreement

  def show
    @agreement = Agreement.find_by!(key: params[:key], version: params[:version])
  end

  def seller_agreement
    @agreement = Agreements::SellerAgreementV1.new.generate_seller_agreement(@designer, request)
    @agreement_signed = @designer.user.legal_entity.agreement_acceptances.where(agreement: Agreement.where(active: true)).exists?
    if @agreement_signed
      @agreement_acceptance = @designer.user.legal_entity.agreement_acceptances.where(agreement: Agreement.where(active: true)).last
    else
      @agreement_acceptance = AgreementAcceptance.new
    end
  end

  def activate
    agreement = Agreement.find_by!(key: params[:key], version: params[:version])
    agreement.update(active: true)
    redirect_to admin_agreements_path, notice: "Agreement activated successfully."
  end

  def deactivate
    agreement = Agreement.find_by!(key: params[:key], version: params[:version])
    agreement.update(active: false)
    redirect_to admin_agreements_path, notice: "Agreement deactivated successfully."
  end

  def destroy
    agreement = Agreement.find_by!(key: params[:key], version: params[:version])
    agreement.destroy
    redirect_to admin_agreements_path, notice: "Agreement deleted successfully."
  end

  private

  def allow_access
    @designer = SoundDesigner.find(params[:id])
    redirect_to settings_path, alert: "You don't have permission to access this page." if @designer != current_user.sound_designer
  end
end
