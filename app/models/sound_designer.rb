class SoundDesigner < ApplicationRecord
  belongs_to :user
  has_many :sfx_packs, dependent: :destroy
  has_many :single_tracks, dependent: :destroy

  validates :first_name, :last_name, presence: true

  has_one_attached :photo

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
