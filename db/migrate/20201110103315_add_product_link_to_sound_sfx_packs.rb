class AddProductLinkToSoundSfxPacks < ActiveRecord::Migration[6.0]
  def change
    add_column :sfx_packs, :product_link, :string
  end
end
