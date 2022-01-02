class ChangeItemsFromCarts < ActiveRecord::Migration[6.0]
  def change
    change_column :carts, :items, :integer, array: true, default: []
    change_column :carts, :sinlge_tracks, :integer, array: true, default: []
  end
end
