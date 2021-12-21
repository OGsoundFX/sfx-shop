class CreateAnnoucements < ActiveRecord::Migration[6.0]
  def change
    create_table :annoucements do |t|
      t.string :title
      t.string :content
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
