class AddServiceNameToActiveStorageBlobs < ActiveRecord::Migration[7.1]
  def change
    add_column :active_storage_blobs, :service_name, :string
  end
end
