class AddBatchToSingleTracks < ActiveRecord::Migration[6.0]
  def change
    add_column :single_tracks, :batch, :integer
  end
end
