class CreateDiscounts < ActiveRecord::Migration[6.0]
  def change
    create_table :discounts do |t|
      t.string :type
      t.decimal :value

      t.timestamps
    end
  end
end
