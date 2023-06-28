class AddLoopToSingleTracks < ActiveRecord::Migration[6.0]
  def change
    add_column :single_tracks, :loop, :boolean, default: :false
  end
end
