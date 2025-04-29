class AddActiveToTemplateCollections < ActiveRecord::Migration[6.0]
  def change
    add_column :template_collections, :active, :boolean, default: true
  end
end
