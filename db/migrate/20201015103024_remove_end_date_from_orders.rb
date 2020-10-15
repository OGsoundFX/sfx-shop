class RemoveEndDateFromOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :end_date, :date
  end
end
