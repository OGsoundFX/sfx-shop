class RemoveKindFromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :kind, :string
  end
end
