class AddMonetize < ActiveRecord::Migration[6.0]
  def change
    remove_column :single_tracks, :price, :decimal
    add_monetize :single_tracks, :price, currency: { present: false }
  end
end
