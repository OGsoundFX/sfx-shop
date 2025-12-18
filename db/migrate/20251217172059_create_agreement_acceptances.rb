class CreateAgreementAcceptances < ActiveRecord::Migration[7.1]
  def change
    create_table :agreement_acceptances do |t|
      t.references :agreement, null: false, foreign_key: true
      t.references :legal_entity, null: false, foreign_key: true
      t.date :accepted_at
      t.string :ip_address
      t.string :user_agent
      t.string :legal_name_snapshot
      t.string :artist_name_snapshot
      t.string :address_snapshot

      t.timestamps
    end
  end
end
