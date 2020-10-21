class AddPacksToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :packs, :integer, array: true, default: []
  end
end
