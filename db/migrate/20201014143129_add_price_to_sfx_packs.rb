class AddPriceToSfxPacks < ActiveRecord::Migration[6.0]
  def change
    add_monetize :sfx_packs, :price, currency: { present: false }
  end
end
