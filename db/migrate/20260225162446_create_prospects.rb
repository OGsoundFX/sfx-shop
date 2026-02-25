class CreateProspects < ActiveRecord::Migration[7.1]
  def change
    create_table :prospects do |t|
      t.string :email
      t.string :artist_name
      t.string :comment
      t.string :source
      t.string :link
      t.boolean :onboard
      t.integer :priority

      t.timestamps
    end
  end
end
