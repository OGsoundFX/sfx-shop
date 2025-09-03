class AddCurrencyToSfxPacks < ActiveRecord::Migration[7.1]
  def change
    add_column :sfx_packs, :currency, :integer, default: 0
  end
end
