class CreatePaymentInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_infos do |t|
      t.integer :preferred_method, default: 0
      t.string :paypal_account
      t.integer :status, default: 0
      t.references :sound_designer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
