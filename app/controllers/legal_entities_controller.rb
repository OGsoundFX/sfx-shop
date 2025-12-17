class LegalEntitiesController < ApplicationController
  def new
    @legal_entity = LegalEntity.new
    @payment_info = @legal_entity.payment_infos.build
  end

  def create
    raise
  end

  private

  def legal_entity_params
    # strong params
    # ! don't forget: permit(..., payment_infos_attributes: [:paypal_account, :preferred_currency])
  end
end
