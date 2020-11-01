class ChangeVersionToFloat < ActiveRecord::Migration[6.0]
  def change
    change_column :sfx_packs, :version, :float
  end
end
