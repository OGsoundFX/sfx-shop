class CreateSoldItems < ActiveRecord::Migration[7.1]
  def change
    create_table :sold_items do |t|
      t.references :sound_designer, null: false, foreign_key: true
      t.references :payout, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.monetize :amount, currency: { present: false }
      t.integer :status
      t.boolean :discount
      t.integer :discount_type

      t.timestamps
    end
  end
end
