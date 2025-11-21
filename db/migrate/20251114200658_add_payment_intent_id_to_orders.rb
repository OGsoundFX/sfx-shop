class AddPaymentIntentIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :payment_intent_id, :string
  end
end
