class AddMonetize < ActiveRecord::Migration[6.0]
  def change
    add_monetize :single_tracks, :price, currency: { present: false }
  end
end
