class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :content
      t.string :author
      t.integer :status
      t.references :user, null: false, foreign_key: true
      t.references :sfx_pack, null: false, foreign_key: true

      t.timestamps
    end
  end
end
