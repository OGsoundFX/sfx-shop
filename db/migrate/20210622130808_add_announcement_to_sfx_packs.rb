class AddAnnouncementToSfxPacks < ActiveRecord::Migration[6.0]
  def change
    add_column :sfx_packs, :announcement, :string
  end
end
