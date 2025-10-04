class AddPreferredCurrencyToPaymentInfos < ActiveRecord::Migration[7.1]
  def change
    add_column :payment_infos, :preferred_currency, :integer
  end
end
