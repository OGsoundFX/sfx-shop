class AddJobIdToDownloadLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :download_links, :job_id, :string
  end
end
