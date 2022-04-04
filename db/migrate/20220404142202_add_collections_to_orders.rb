class AddCollectionsToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :collections, :integer, array: true, default: []
  end
end
