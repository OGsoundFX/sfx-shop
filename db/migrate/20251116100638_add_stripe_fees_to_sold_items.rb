class AddStripeFeesToSoldItems < ActiveRecord::Migration[7.1]
  def change
    add_monetize :sold_items, :stripe_fees, currency: { present: false }
  end
end
