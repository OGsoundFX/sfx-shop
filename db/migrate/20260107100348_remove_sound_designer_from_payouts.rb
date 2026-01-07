class RemoveSoundDesignerFromPayouts < ActiveRecord::Migration[7.1]
  def up
    add_reference :payouts, :legal_entity, null: true, foreign_key: true

    Payout.reset_column_information
    Payout.find_each do |payout|
      sound_designer = SoundDesigner.find(payout.sound_designer_id)
      if sound_designer
        legal_entity = sound_designer.legal_entity
        payout.update!(legal_entity_id: legal_entity.id)
      else
        raise ActiveRecord::RecordNotFound, "SoundDesigner with id #{payout.sound_designer_id} not found"
      end
    end

    # Step 5: enforce NOT NULL now that all rows are populated
    change_column_null :payouts, :legal_entity_id, false

    remove_reference :payouts, :sound_designer
  end

  def down
    remove_reference :payouts, :legal_entity
    add_reference :payouts, :sound_designer, null: false, foreign_key: true
  end
end
