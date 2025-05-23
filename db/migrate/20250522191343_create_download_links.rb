class CreateDownloadLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :download_links do |t|
      t.string :url
      t.string :token
      t.datetime :validity_duration
      t.references :collection, foreign_key: true
      t.boolean :collection_download
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
