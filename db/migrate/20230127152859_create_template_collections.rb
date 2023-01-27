class CreateTemplateCollections < ActiveRecord::Migration[6.0]
  def change
    create_table :template_collections do |t|
      t.string :title
      t.integer :total_points
      t.integer :tracks, array: true, default: []
      t.string :categories, array: true, default: []

      t.timestamps
    end
    add_monetize :template_collections, :price, currency: { present: false }
  end
end
