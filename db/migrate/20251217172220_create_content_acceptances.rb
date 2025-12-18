class CreateContentAcceptances < ActiveRecord::Migration[7.1]
  def change
    create_table :content_acceptances do |t|
      t.references :legal_entity, null: false, foreign_key: true
      t.references :sfx_pack, null: false, foreign_key: true
      t.date :accepted_at
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end
end
