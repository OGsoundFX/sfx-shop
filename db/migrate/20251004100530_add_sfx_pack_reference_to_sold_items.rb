class AddSfxPackReferenceToSoldItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :sold_items, :sfx_pack, foreign_key: true, null: true
  end
end
