class SingleTrack < ApplicationRecord
  belongs_to :sound_designer
  monetize :price_cents

  enum announcement: [:standard, :new_release, :popular, :deal]

  include PgSearch::Model
  pg_search_scope :search_single_tracks,
    against: [ :title, :category, :tags ],
    using: {
      tsearch: { prefix: true }
    }

  def self.categories
    {
      all: '<i class="fas fa-volume-up"></i>',
      action: '<i class="fas fa-swords"></i>',
      medieval: '<i class="fab fa-fort-awesome"></i>',
      outdoor:	'<i class="fas fa-trees"></i>',
      underground: '<i class="fas fa-dungeon"></i>',
      scary:	'<i class="fas fa-ghost"></i>',
      monsters:	'<i class="fas fa-dragon"></i>',
      disasters: '<i class="fas fa-volcano"></i>',
      weather: '<i class="fas fa-cloud-showers-heavy"></i>',
      default: '<i class="fas fa-volume-up"></i>'
    }
  end
end
