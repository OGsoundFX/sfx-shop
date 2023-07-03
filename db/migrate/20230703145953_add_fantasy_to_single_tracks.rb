class AddFantasyToSingleTracks < ActiveRecord::Migration[6.0]
  def change
    add_column :single_tracks, :fantasy, :boolean, default: false
  end
end
