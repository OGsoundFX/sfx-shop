class CreateLegalEntities < ActiveRecord::Migration[7.1]
  def change
    create_table :legal_entities do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :entity_type
      t.string :legal_name
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :street_name
      t.string :street_number
      t.string :address_line_2
      t.string :postal_code
      t.string :city
      t.string :state
      t.string :country

      t.timestamps
    end
  end
end
