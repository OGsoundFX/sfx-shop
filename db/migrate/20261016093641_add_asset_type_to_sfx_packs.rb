class AddAssetTypeToSfxPacks < ActiveRecord::Migration[7.1]
  def change
    add_column :sfx_packs, :asset_type, :integer, default: 0
  end
end
