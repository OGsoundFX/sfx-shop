class CreateCurrencyRates < ActiveRecord::Migration[7.1]
  def change
    create_table :currency_rates do |t|
      t.string :base, null: false
      t.string :target, null: false
      t.decimal :rate, precision: 12, scale: 6

      t.timestamps
    end
  end
end
