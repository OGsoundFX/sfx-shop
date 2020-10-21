class AddMultipleToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :multiple, :boolean, default: false
  end
end
