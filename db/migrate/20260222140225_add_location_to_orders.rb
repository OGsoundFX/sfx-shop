class AddLocationToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :location, :string
  end
end
