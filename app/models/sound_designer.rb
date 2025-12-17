class SoundDesigner < ApplicationRecord
  after_create_commit :update_user

  belongs_to :user
  has_many :sfx_packs, dependent: :destroy
  has_many :single_tracks, dependent: :destroy
  has_many :sold_items
  has_many :payouts

  validates :artist_name, presence: true

  has_one_attached :photo
  has_one_attached :banner

  def legal_entity
    self.user.legal_entity
  end

  private

  def update_user
    user = self.user
    user.designer = true
    user.save
  end
end
