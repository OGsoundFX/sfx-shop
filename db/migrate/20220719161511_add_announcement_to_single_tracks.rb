class AddAnnouncementToSingleTracks < ActiveRecord::Migration[6.0]
  def change
    add_column :single_tracks, :announcement, :integer
  end
end
