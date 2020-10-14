class AddStartDateToDiscounts < ActiveRecord::Migration[6.0]
  def change
    add_column :discounts, :start_date, :date
  end
end
