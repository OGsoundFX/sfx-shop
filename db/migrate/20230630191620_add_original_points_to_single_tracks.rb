class AddOriginalPointsToSingleTracks < ActiveRecord::Migration[6.0]
  def change
    add_column :single_tracks, :original_points, :integer, default: 0
  end
end
