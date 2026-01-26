class AddColumnsToSfxPacks < ActiveRecord::Migration[7.1]
  def change
    add_column :sfx_packs, :sample_rate, :integer
    add_column :sfx_packs, :bit_depth, :integer
  end
end
