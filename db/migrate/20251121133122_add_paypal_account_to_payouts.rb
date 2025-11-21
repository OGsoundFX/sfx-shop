class AddPaypalAccountToPayouts < ActiveRecord::Migration[7.1]
  def change
    add_column :payouts, :paypal_account, :string
  end
end
