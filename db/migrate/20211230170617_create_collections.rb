class CreateCollections < ActiveRecord::Migration[6.0]
  def change
    create_table :collections do |t|
      t.integer :total_points
      t.integer :tracks, array: true, default: []
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_monetize :collections, :price, currency: { present: false }
  end
end
