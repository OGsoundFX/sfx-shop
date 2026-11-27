class SfxPack < ApplicationRecord
  before_commit :generate_summary

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
  has_many_attached :photos, service: Rails.env.production? ? :aws_s3_pack_covers : :cloudinary, dependent: :destroy
  # has_many_attached :photos, service: :aws_s3_pack_covers, dependent: :destroy

  # The banner is not used in the app. When decided to implement, please use AWS S3 for attachment
  # has_one_attached :banner
  has_one_attached :sound_list
  monetize :price_cents
  has_many :sold_items, dependent: :nullify

  validate :price_presence

  # enum for asset_type
  enum asset_type: { sfx: 0, music: 1}

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

  validates :title, :summary, :rich_description, :size_mb, :category, :tags, :number_of_tracks, :price, :currency, :link, :product_link, :sample_rate, :bit_depth, :asset_type, presence: true
  validates :title, length: { minimum: 3, maximum: 60 }
  validates :summary, length: { minimum: 10, maximum: 200 }
  validate :rich_description_minimum_length
  validates :link, format: {
    with: /\Ahttps?:\/\/(?:[\w-]+\.)*(?:soundcloud\.com|youtube\.com|youtu\.be)(\/[\w\-\.~:\/\?\#\[\]@!\$&'\(\)\*\+,;=]*)?\z/i,
    message: 'must be a valid SoundCloud or YouTube URL'
  }
  validates :product_link, format: {
    with: /\Ahttps?:\/\/[\w\-.]+(\.[a-z]{2,})(\/[\w\-\.~:\/\?\#\[\]@!\$&'\(\)\*\+,;=]*)?\z/i,
    message: 'must be a valid URL'
  }
  validates :sample_rate, inclusion: { in: [44100, 48000, 96000]}
  validates :bit_depth, inclusion: { in: [16, 24, 32]}
  validates :accept_conditions, acceptance: true
  validates :announcement, inclusion: { in: [nil, 'NEW !!!', 'UPGRADE', 'POPULAR'], message: "%{value} is not included in the list ['NEW !!!', 'UPGRADE', 'POPULAR']" }

  validate :photo_presence, :categories_max, :tags_max

  has_rich_text :rich_description

  def price_presence
    if price_cents.to_i < 0
      errors.add(:price, "can't be negative")
      errors.add(:price_cents, "can't be negative")
    end
  end

  def to_param
    "#{id} #{title}".parameterize
  end

  def average_rating
    (reviews.sum { |review| review.rating } / reviews.count.to_f).ceil(1) if reviews.present?
  end

  def youtube_video_id
    uri = URI.parse(link)
    host = uri.host&.downcase
    return unless host && (host == "youtu.be" || host.end_with?(".youtu.be") ||
                           host == "youtube.com" || host.end_with?(".youtube.com"))

    video_id = if host == "youtu.be" || host.end_with?(".youtu.be")
      uri.path.split("/")[1]
    elsif uri.path == "/watch"
      URI.decode_www_form(uri.query.to_s).assoc("v")&.last
    else
      uri.path.match(%r{\A/(?:embed|v|shorts|live)/([^/]+)})&.captures&.first
    end

    video_id if video_id&.match?(/\A[A-Za-z0-9_-]{11}\z/)
  rescue URI::InvalidURIError, ArgumentError
    nil
  end

  def generate_summary_task
    generate_summary
  end

  private

  def photo_presence
    if photos.blank? || photos.none?
      errors.add(:photos, "must be attached")
    end
  end

  def rich_description_minimum_length
    return if rich_description.to_plain_text.length >= 20

    errors.add(:rich_description, :too_short, count: 20)
  end

  def categories_max
    return if category.blank?

    if category.split(", ").size > 3
      errors.add(:category, ": You can only select 3 categories maximum")
    end
  end

  def tags_max
    return if category.blank?

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

  def generate_summary
    if summary.blank? && rich_description.present?
      if rich_description.length <= 200
        self.summary = rich_description
      else
        # count chars until last punctuation mark before 200 chars
        last_punctuation_index = rich_description[0..199].rindex(/[.!?]/)
        if last_punctuation_index.present?
          self.summary = rich_description[0..last_punctuation_index]
        else
          self.summary = rich_description.truncate(200, separator: ' ')
        end
      end
    end
  end
end
