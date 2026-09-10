class AddPayoutProcessedAtToSoldItems < ActiveRecord::Migration[6.0]
  def change
    add_column :sold_items, :payout_processed_at, :datetime
  end
end
