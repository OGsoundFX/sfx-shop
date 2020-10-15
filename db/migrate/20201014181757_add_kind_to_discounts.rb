class AddKindToDiscounts < ActiveRecord::Migration[6.0]
  def change
    add_column :discounts, :kind, :string
  end
end
