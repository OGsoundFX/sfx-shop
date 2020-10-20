class CreateCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :carts do |t|
      t.text :items, array: true, default: []
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
