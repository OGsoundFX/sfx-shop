class RemoveItemsFromCarts < ActiveRecord::Migration[6.0]
  def change
    remove_column :carts, :items, :text
    add_column :carts, :items, :integer, array: true
  end
end
