require 'pry'

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
      action: '<i class="fas fa-bomb"></i>',
      medieval: '<i class="fab fa-fort-awesome"></i>',
      outdoor:	'<i class="fas fa-tree"></i>',
      underground: '<i class="fas fa-dungeon"></i>',
      scary:	'<i class="fas fa-ghost"></i>',
      monsters:	'<i class="fas fa-dragon"></i>',
      disasters: '<i class="fas fa-mountain"></i>',
      weather: '<i class="fas fa-cloud-showers-heavy"></i>',
      miscellaneous: '<i class="fas fa-volume-up"></i>',
      footsteps: '<i class="fas fa-shoe-prints"></i>',
      magic: '<i class="fas fa-hat-wizard"></i>',
      scifi: '<i class="fas fa-rocket"></i>',
      default: '<i class="fas fa-volume-up"></i>'
    }
  end

  def self.points_grid
    {
      "2":	892000,
      "3":	1191000,
      "5":	1756000,
      "10":	3170000,
      "15":	4620000,
      "20":	6330000,
      "30":	8786000,
      "39":	11000000,
      "50":	14000000,
      "60":	17360000,
      "90":	26000000,
      "120": 42400000
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
    grid = SingleTrack.alt_grid_1
    tracks = SingleTrack.all
    tracks.each do |track|
      case track.size
      when 0..1191000
        track.points = grid[:'1191000']
      when 1191001..4620000
        track.points = grid[:'4620000']
      when 4620001..11000000
        track.points = grid[:'11000000']
      when 11000001..26000000
        track.points = grid[:'26000000']
      else
        track.points = 5
      end
      # binding.pry if track.original_points == 3
      track.save
    end
  end

  def self.back_to_standard
    SingleTrack.all.each do |track|
      track.points = track.original_points
      track.save
    end
  end

  def fantasy_converter
    self.fantasy = true if self.tags.include?("fantasy")
    self.save
  end

  private

  def self.alt_grid_1
    {
      '1191000': 1,
      '4620000': 2,
      '11000000': 3,
      '26000000': 4,
    }
  end
end
