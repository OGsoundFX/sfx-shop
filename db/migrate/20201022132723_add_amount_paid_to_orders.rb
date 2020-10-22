class AddAmountPaidToOrders < ActiveRecord::Migration[6.0]
  def change
    add_monetize :orders, :amount_paid
  end
end
