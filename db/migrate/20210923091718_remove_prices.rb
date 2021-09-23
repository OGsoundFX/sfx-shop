class RemovePrices < ActiveRecord::Migration[6.0]
  def change
    remove_column :single_tracks, :price_cents
    add_monetize :single_tracks, :price, currency: { present: false }
  end
end
