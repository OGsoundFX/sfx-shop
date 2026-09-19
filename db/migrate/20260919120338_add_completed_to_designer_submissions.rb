class AddCompletedToDesignerSubmissions < ActiveRecord::Migration[7.1]
  def change
    add_column :designer_submissions, :completed, :boolean, default: false
  end
end
