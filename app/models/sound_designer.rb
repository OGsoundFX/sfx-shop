class SoundDesigner < ApplicationRecord
  has_many :sfx_packs, dependent: :destroy
end
