class AddCollectionsToCarts < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :collections, :integer, array: true, default: []
  end
end
