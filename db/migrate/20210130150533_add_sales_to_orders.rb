class AddSalesToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :sales, :json, default: {}
  end
end
