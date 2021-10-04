class AddSingleTracksToCart < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :sinlge_tracks, :integer, array: true
  end
end
