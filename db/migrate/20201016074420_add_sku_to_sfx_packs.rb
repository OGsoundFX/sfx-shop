class AddSkuToSfxPacks < ActiveRecord::Migration[6.0]
  def change
    add_column :sfx_packs, :sku, :string
  end
end
