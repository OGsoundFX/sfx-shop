class AddColumnsToSingleTracks < ActiveRecord::Migration[7.1]
  def change
    add_column :single_tracks, :asset_type, :integer, default: 0
    add_column :single_tracks, :includes_ai, :boolean, default: false, null: false
  end
end
