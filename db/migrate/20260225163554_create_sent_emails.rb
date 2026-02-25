class CreateSentEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :sent_emails do |t|
      t.references :prospect, null: false, foreign_key: true
      t.date :date
      t.string :email_sequence
      t.boolean :responded
      t.integer :response_type
      t.text :response

      t.timestamps
    end
  end
end
