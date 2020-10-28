class AddVersionToSfxPack < ActiveRecord::Migration[6.0]
  def change
    add_column :sfx_packs, :version, :integer
    add_column :sfx_packs, :link, :string
    add_column :sfx_packs, :list, :string
  end
end
