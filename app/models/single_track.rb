class SingleTrack < ApplicationRecord
  belongs_to :sound_designer
  monetize :price_cents

  include PgSearch::Model
  pg_search_scope :search_single_tracks,
    against: [ :title, :category, :tags ],
    using: {
      tsearch: { prefix: true }
    }
end
