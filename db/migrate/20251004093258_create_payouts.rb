class CreatePayouts < ActiveRecord::Migration[7.1]
  def change
    create_table :payouts do |t|
      t.references :sound_designer, null: false, foreign_key: true
      t.integer :status, default: 0
      t.date :payout_date
      t.string :fail_reason
      t.integer :currency
      t.monetize :amount, currency: { present: false }

      t.timestamps
    end
  end
end
