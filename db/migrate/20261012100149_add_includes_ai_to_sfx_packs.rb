class AddIncludesAiToSfxPacks < ActiveRecord::Migration[7.1]
  def change
    add_column :sfx_packs, :includes_ai, :boolean, default: false, null: false
  end
end
