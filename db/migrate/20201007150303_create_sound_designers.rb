class CreateSoundDesigners < ActiveRecord::Migration[6.0]
  def change
    create_table :sound_designers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password
      t.string :address
      t.string :location

      t.timestamps
    end
  end
end
