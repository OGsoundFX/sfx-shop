class SoundDesigner < ApplicationRecord
  belongs_to :user
  has_many :sfx_packs, dependent: :destroy
  has_many :single_tracks, dependent: :destroy

  has_one_attached :photo
end
