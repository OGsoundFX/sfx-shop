class RemoveReferencesFromPaymentInfos < ActiveRecord::Migration[7.1]
  def change
    remove_reference :payment_infos, :sound_designer, null: false, foreign_key: true
    add_reference :payment_infos, :legal_entity, null: false, foreign_key: true
  end
end
