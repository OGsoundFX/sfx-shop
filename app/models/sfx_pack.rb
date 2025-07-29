class SfxPack < ApplicationRecord
  belongs_to :sound_designer
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :photos, dependent: :destroy
  has_one_attached :banner
  monetize :price_cents

  enum status: ["draft", "submitted", "live", "declined"]

  def to_param
    "#{id} #{title}".parameterize
  end

  def average_rating
    (reviews.sum { |review| review.rating } / reviews.count.to_f).ceil(1) if reviews.present?
  end
end
