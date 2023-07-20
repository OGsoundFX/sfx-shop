class TemplateCollection < ApplicationRecord
  before_validation :order_tracks
  monetize :price_cents

  validates :title, presence: true, uniqueness: true
  validates :tracks, uniqueness: true

  def order_tracks
    self.tracks = self.tracks.sort
  end

  # use this method to recalculate the price of all un-purchased collections if there has been a change in the points of any track
  def self.recalculate
    self.all.each do |collection|
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
