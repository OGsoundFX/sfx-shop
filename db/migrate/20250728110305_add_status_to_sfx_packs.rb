class AddStatusToSfxPacks < ActiveRecord::Migration[7.1]
  def change
    add_column :sfx_packs, :status, :integer
  end
end
