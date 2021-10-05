class AddTracksToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :tracks, :integer, array: true, default: []
  end
end
