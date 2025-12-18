class RemoveColumnsFromSoundDesigners < ActiveRecord::Migration[7.1]
  def change
    remove_column :sound_designers, :first_name, :string
    remove_column :sound_designers, :last_name, :string
    remove_column :sound_designers, :address, :string

    add_column :sound_designers, :artist_name, :string
  end
end
