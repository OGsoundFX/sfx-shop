class RemovePriceRangeFromCollectionCategories < ActiveRecord::Migration[6.0]
  def change
    remove_column :collection_categories, :price_range, :integer
    add_column :collection_categories, :points, :integer
  end
end
