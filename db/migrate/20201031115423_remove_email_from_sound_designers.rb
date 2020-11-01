class RemoveEmailFromSoundDesigners < ActiveRecord::Migration[6.0]
  def change
    remove_column :sound_designers, :email, :string
    remove_column :sound_designers, :password, :string
    add_column :sound_designers, :bio, :text
    add_column :users, :designer, :boolean, default: false
    add_reference :sound_designers, :user, foreign_key: true
  end
end
