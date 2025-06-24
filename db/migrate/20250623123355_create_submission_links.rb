class CreateSubmissionLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :submission_links do |t|
      t.string :url
      t.string :title
      t.text :description
      t.references :designer_submission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
