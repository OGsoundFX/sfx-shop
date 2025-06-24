class CreateDesignerSubmissions < ActiveRecord::Migration[7.1]
  def change
    create_table :designer_submissions do |t|
      t.string :first_name
      t.string :last_name
      t.string :location
      t.string :email
      t.string :random_password
      t.boolean :individual_tracks
      t.integer :status

      t.timestamps
    end
  end
end
