class AgreementsController < ApplicationController
  before_action :authenticate_user!

  def show
    @agreement = Agreement.find_by!(key: params[:key], version: params[:version])
  end

  def seller_agreement
    @designer = SoundDesigner.find(params[:id])
    # @agreement = Agreement.where(active: true).order(version: :desc).first
    @agreement = Agreements::SellerAgreementV1.generate_seller_agreement(@designer, request)
    @agreement_signed = @designer.user.legal_entity.agreement_acceptances.where(agreement: Agreement.where(active: true)).exists?
    @agreement_acceptance = AgreementAcceptance.new
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
end
