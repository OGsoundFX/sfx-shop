class SfxPack < ApplicationRecord
  before_destroy :purge_photos

  belongs_to :sound_designer
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :photos, dependent: :destroy
  has_one_attached :banner
  monetize :price_cents

  # enum status: ["draft", "submitted", "live", "declined"]
  enum status: { draft: 0, submitted: 1, live: 2, declined:3 }

  validates :title, :size_mb, :description, :category, :duration, :number_of_tracks, :price, :link, :list, presence: true
  # validates :price, numericality: { only_integer: true }
  validate :photo_presence
  validate :categories

  def to_param
    "#{id} #{title}".parameterize
  end

  def average_rating
    (reviews.sum { |review| review.rating } / reviews.count.to_f).ceil(1) if reviews.present?
  end

  private

  def photo_presence
    if photos.blank? || photos.none?
      errors.add(:photos, "must be attached")
    end
  end

  def categories
    if category.split(", ").size > 3
      errors.add(:category, "You can only pick 3")
    end
  end

  def purge_photos
    photos.each(&:purge_later)
  end

end
