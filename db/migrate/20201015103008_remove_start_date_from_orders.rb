class RemoveStartDateFromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :start_date, :date
  end
end
