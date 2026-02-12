class AddAcceptConditionsToSfxPacks < ActiveRecord::Migration[7.1]
  def change
    add_column :sfx_packs, :accept_conditions, :boolean, default: false
  end
end
