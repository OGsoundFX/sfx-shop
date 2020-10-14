class AddEndDateToDiscounts < ActiveRecord::Migration[6.0]
  def change
    add_column :discounts, :end_date, :date
  end
end
