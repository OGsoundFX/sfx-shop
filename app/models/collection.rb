class Collection < ApplicationRecord
  belongs_to :user
  monetize :price_cents
end
