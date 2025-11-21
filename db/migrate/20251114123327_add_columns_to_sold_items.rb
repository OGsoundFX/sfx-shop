class AddColumnsToSoldItems < ActiveRecord::Migration[7.1]
  def change
    add_column :sold_items, :currency, :integer
    add_column :sold_items, :payout_currency, :integer
    add_monetize :sold_items, :payout_amount, currency: { present: false }
  end
end
