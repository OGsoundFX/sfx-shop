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
      miscellaneous: '<i class="fas fa-volume-up"></i>',
      footsteps: '<i class="fas fa-shoe-prints"></i>',
      magic: '<i class="fas fa-cauldron"></i>',
      scifi: '<i class="fas fa-rocket"></i>',
      default: '<i class="fas fa-volume-up"></i>'
    }
  end

  before_create do
    self.announcement = :new_release
  end

  def self.popular
    track_array = Order.pluck(:tracks).flatten + Collection.where(purchased: true).pluck(:tracks).flatten
    track_hash = {}
    track_array.each do |track|
      track_hash[track] = track_array.count(track)
    end
    sorted = track_hash.sort_by { |k, v| -v }
    final_list = sorted.first(100).map do |pair|
      pair.first
    end
    final_list.each do |track|
      SingleTrack.find(track).update(announcement: "popular")
    end
  end

  def self.check_new(months)
    tracks = SingleTrack.where(announcement: "new_release").where("created_at < ?", months.months.ago)
    tracks.update(announcement: "standard")
  end

  def self.new_points_grid
    tracks = SingleTrack.all
    
  end
end
