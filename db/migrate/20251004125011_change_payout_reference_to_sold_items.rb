class ChangePayoutReferenceToSoldItems < ActiveRecord::Migration[7.1]
  def change
    remove_reference :sold_items, :payout
    add_reference :sold_items, :payout, foreign_key: true, null: true
  end
end
