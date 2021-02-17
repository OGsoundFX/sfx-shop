class AddDisplayOrderToSfxPacks < ActiveRecord::Migration[6.0]
  def change
    add_column :sfx_packs, :display_order, :integer
  end
end
