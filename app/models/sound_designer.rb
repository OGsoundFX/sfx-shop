class SoundDesigner < ApplicationRecord
  has_many :sfx_packs, dependent: :destroy
  has_many :single_tracks, dependent: :destroy
end
