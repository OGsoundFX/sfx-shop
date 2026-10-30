class Collection < ApplicationRecord
  belongs_to :user
  belongs_to :template_collection, optional: true
  has_many :download_links, dependent: :destroy

  monetize :price_cents

  validates :total_points, numericality: { less_than_or_equal_to: 300, message: "Can't exceed 300 points, please create a new Collection" }

  # use this method to recalculate the price of all un-purchased collections if there has been a change in the points of any track
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
    currencies = {
      "€" => [0, 500, 1000, 2000, 4000, 5000],
      "$" => [0, 500, 1000, 2000, 4000, 5000],
    }

    index = case points
    when 0 then 0
    when 1..20 then 1
    when 21..50 then 2
    when 51..120 then 3
    when 121..300 then 4
    else 5
    end

    currencies.fetch(session[:currency], "$")[index]
  end

  def recalculate_collection_values
    self.total_points = tracks.sum { SingleTrack.find(it).points }
    self.price_cents = collection_categories(total_points)
    self.save
  end
end
