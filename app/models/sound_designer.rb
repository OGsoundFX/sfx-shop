class SoundDesigner < ApplicationRecord
  after_create_commit :update_user

  belongs_to :user
  has_many :sfx_packs, dependent: :destroy
  has_many :single_tracks, dependent: :destroy
  has_many :payment_infos, dependent: :destroy

  validates :first_name, :last_name, presence: true

  has_one_attached :photo

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  private

  def update_user
    user = self.user
    user.designer = true
    user.save
  end
end
