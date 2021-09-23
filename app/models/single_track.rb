class SingleTrack < ApplicationRecord
  belongs_to :sound_designer
  monetize :price_cents
end
