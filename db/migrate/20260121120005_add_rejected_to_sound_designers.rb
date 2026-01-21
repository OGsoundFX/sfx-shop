class AddRejectedToSoundDesigners < ActiveRecord::Migration[7.1]
  def change
    add_column :sound_designers, :rejected, :boolean, default: false
  end
end
