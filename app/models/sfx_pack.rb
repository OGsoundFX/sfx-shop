class SfxPack < ApplicationRecord
  TAGS = [
    "fantasy", "guns", "explosions", "natural", "disasters", "horror", "nature", "atmospheres",
    "catastrophe", "volcano", "eruption", "earthquake", "landslide", "avalanche", "scary", "monster",
    "action", "adventure", "underground", "cavern", "winds", "rain", "thunder", "war", "realistic",
    "battle", "halloween", "ghost", "haunted", "supernatural", "outdoor", "roars", "growls", "swords",
    "arrows", "magic", "spells", "dragons", "zombies", "fire", "lava", "water", "ice", "claws",
    "teleport", "shield", "trap", "clicks", "footsteps", "heartbeat"
  ].freeze

  before_destroy :purge_files

  belongs_to :sound_designer
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :photos, dependent: :destroy
  has_one_attached :banner
  has_one_attached :sound_list
  monetize :price_cents

  # enum status: ["draft", "submitted", "live", "declined"]
  enum status: { draft: 0, submitted: 1, live: 2, declined:3 }

  validates :title, :size_mb, :description, :category, :tags, :number_of_tracks, :price,:link, :product_link, presence: true
  validates :link, :product_link, format: {
    with: /\Ahttps?:\/\/[\w\-.]+(\.[a-z]{2,})(\/[\w\-\.~:\/\?\#\[\]@!\$&'\(\)\*\+,;=]*)?\z/i,
    message: 'must be a valid URL'
  }

  validate :photo_presence, :categories_max, :tags_max

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

  def categories_max
    if category.split(", ").size > 3
      errors.add(:category, ": You can only select 3 categories maximum")
    end
  end

  def tags_max
    if tags.split(", ").size > 10
      errors.add(:tags, ": You can only select 10 tags maximum")
    end
  end

  def purge_files
    photos.each(&:purge_later)
    sound_list.purge_later
  end
end
