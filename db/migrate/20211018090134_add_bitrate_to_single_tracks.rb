class AddBitrateToSingleTracks < ActiveRecord::Migration[6.0]
  def change
    add_column :single_tracks, :bitrate, :integer
    add_column :single_tracks, :sample_rate, :integer
  end
end
