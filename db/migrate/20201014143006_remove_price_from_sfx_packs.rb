class RemovePriceFromSfxPacks < ActiveRecord::Migration[6.0]
  def change
    remove_column :sfx_packs, :price, :decimal
  end
end
