class Collection < ApplicationRecord
  belongs_to :user
  monetize :price_cents

  validates :total_points, numericality: { less_than_or_equal_to: 300, message: "Can't exceed 300 points, please create a new Collection" }

  def self.recalculate
    self.where(purchased: false).each do |collection|
      points = 0
      collection.tracks.each do |track|
        points += SingleTrack.find(track).points
      end
      collection.total_points = points
      collection.price_cents = collection.collection_categories(points)
      collection.save
    end
  end

  def collection_categories(points)
    case
    when points == 0
      0
    when points <= 20
      500
    when points <= 50 
      1000
    when points <= 120
      2000
    when points <= 300
      4000
    else
      5000 # unlimited
    end
  end
end
