class CreateSales < ActiveRecord::Migration[6.0]
  def change
    create_table :sales do |t|
      t.string :title
      t.integer :percentage
      t.date :start_date
      t.date :end_date
      t.integer :packs, array: true, default: []

      t.timestamps
    end
  end
end
