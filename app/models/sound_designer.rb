class SoundDesigner < ApplicationRecord
  after_create_commit :update_user

  belongs_to :user
  has_many :sfx_packs, dependent: :destroy
  has_many :single_tracks, dependent: :destroy
  has_many :payment_infos, dependent: :destroy
  has_many :sold_items
  has_many :payouts

  accepts_nested_attributes_for :payment_infos, allow_destroy: true

  validates :first_name, :last_name, presence: true

  has_one_attached :photo
  has_one_attached :banner

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
