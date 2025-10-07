class AddUserReferenceToDesignerSubmissions < ActiveRecord::Migration[7.1]
  def change
    add_reference :designer_submissions, :user, null: true, foreign_key: true
  end
end
