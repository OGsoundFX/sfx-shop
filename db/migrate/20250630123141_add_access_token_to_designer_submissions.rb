class AddAccessTokenToDesignerSubmissions < ActiveRecord::Migration[7.1]
  def change
    add_column :designer_submissions, :access_token, :string
    add_index :designer_submissions, :access_token, unique: true
  end
end
