class SfxPack < ApplicationRecord
  belongs_to :sound_designer
  has_many_attached :photos, dependent: :destroy
  monetize :price_cents
end
