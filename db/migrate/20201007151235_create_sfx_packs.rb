class CreateSfxPacks < ActiveRecord::Migration[6.0]
  def change
    create_table :sfx_packs do |t|
      t.string :title
      t.text :description
      t.string :category
      t.string :tags
      t.integer :size_mb
      t.string :duration
      t.integer :number_of_tracks
      t.decimal :price
      t.references :sound_designer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
