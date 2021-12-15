class AddPreviewLinkToSingleTracks < ActiveRecord::Migration[6.0]
  def change
    add_column :single_tracks, :preview_link, :string
  end
end
