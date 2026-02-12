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
  has_many :sold_items, dependent: :nullify

  # enum for status
  enum status: { draft: 0, submitted: 1, live: 2, declined:3, removed: 4 }

  # enum for currencies
  enum currency: { eur: 0, usd: 1}
  CURRENCY_SYMBOLS = {
    "eur" => "€",
    "usd" => "$"
  }.freeze

  def currency_symbol
    CURRENCY_SYMBOLS[currency]
  end

  validates :title, :description, :size_mb, :category, :tags, :number_of_tracks, :price, :currency, :link, :product_link, :sample_rate, :bit_depth, presence: true
  validates :description, length: { minimum: 20 }
  validates :description, length: { minimum: 5 }
  validates :link, :product_link, format: {
    with: /\Ahttps?:\/\/[\w\-.]+(\.[a-z]{2,})(\/[\w\-\.~:\/\?\#\[\]@!\$&'\(\)\*\+,;=]*)?\z/i,
    message: 'must be a valid URL'
  }
  validates :sample_rate, inclusion: { in: [44100, 48000]}
  validates :bit_depth, inclusion: { in: [16, 24, 32]}
  validates :accept_conditions, acceptance: true

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

  def self.categories
    ["action", "medieval", "outdoor", "underground", "scary", "monsters", "disasters", "weather", "miscellaneous", "footsteps", "magic", "scifi"]
  end
end
