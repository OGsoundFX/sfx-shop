class AddSummaryToSfxPacks < ActiveRecord::Migration[7.1]
  def change
    add_column :sfx_packs, :summary, :text
  end
end
