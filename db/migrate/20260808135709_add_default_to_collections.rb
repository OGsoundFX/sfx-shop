class AddDefaultToCollections < ActiveRecord::Migration[7.1]
  def change
    change_column_default :collections, :total_points, from: nil, to: 0
  end
end
