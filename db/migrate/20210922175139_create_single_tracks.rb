class CreateSingleTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :single_tracks do |t|
      t.string :title
      t.text :description
      t.string :category
      t.string :tags, array: true, default: []
      t.integer :size
      t.time :duration
      t.integer :points
      t.string :sku
      t.string :link
      t.integer :display_order
      t.integer :sfx_pack_id
      t.references :sound_designer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
