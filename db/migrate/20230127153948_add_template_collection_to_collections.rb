class AddTemplateCollectionToCollections < ActiveRecord::Migration[6.0]
  def change
    add_reference :collections, :template_collection, foreign_key: true
  end
end
