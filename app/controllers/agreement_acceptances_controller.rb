class AgreementAcceptancesController < ApplicationController
  def create
    @designer = SoundDesigner.find(params[:sound_designer_id])
    @agreement = Agreement.find(params[:agreement_acceptance][:agreement_id])
    @agreement_acceptance = AgreementAcceptance.new(
      agreement: @agreement,
      legal_entity: @designer.legal_entity,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      accepted_at: Date.today,
      legal_name_snapshot: @designer.legal_entity.legal_name,
      artist_name_snapshot: @designer.artist_name,
      address_snapshot: @designer.legal_entity.address
    )
    if @agreement_acceptance.save && params[:agreement_acceptance][:accepted] == "1"
      redirect_to settings_path, notice: "Agreement accepted successfully."
    else
      render "agreements/seller_agreement", status: :unprocessable_entity
    end
  end
end
