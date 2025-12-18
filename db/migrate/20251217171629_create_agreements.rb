class CreateAgreements < ActiveRecord::Migration[7.1]
  def change
    create_table :agreements do |t|
      t.string :key
      t.string :version
      t.string :title
      t.boolean :active
      t.date :published_at

      t.timestamps
    end
  end
end
