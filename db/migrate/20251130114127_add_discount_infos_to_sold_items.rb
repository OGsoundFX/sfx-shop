class AddDiscountInfosToSoldItems < ActiveRecord::Migration[7.1]
  def change
    add_column :sold_items, :discount_percentage, :integer
    add_column :sold_items, :discount_name, :string
  end
end
