class AddStatusToLegalEntities < ActiveRecord::Migration[7.1]
  def change
    add_column :legal_entities, :status, :integer
  end
end
