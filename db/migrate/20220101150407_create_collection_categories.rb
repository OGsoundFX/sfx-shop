class CreateCollectionCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :collection_categories do |t|
      t.integer :price_range, array: true, default: []

      t.timestamps
    end
    add_monetize :collection_categories, :price, currency: { present: false }
  end
end
