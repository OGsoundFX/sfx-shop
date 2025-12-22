class AgreementsController < ApplicationController
  before_action :authenticate_user!

  def show
    @agreement = Agreement.find_by!(key: params[:key], version: params[:version])
  end

  def seller_agreement
    @designer = SoundDesigner.find(params[:id])
    # @agreement = Agreement.where(active: true).order(version: :desc).first
    @agreement = Agreements::SellerAgreementV1.generate_seller_agreement(@designer, request)
  end
end
