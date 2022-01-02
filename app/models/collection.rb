class Collection < ApplicationRecord
  belongs_to :user
  monetize :price_cents

  validates :total_points, numericality: { less_than_or_equal_to: 300, message: "Can't exceed 300 points, please create a new Collection" }
end
