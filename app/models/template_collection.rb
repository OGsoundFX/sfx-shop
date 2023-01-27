class TemplateCollection < ApplicationRecord
  before_validation :order_tracks
  monetize :price_cents

  validates :title, presence: true, uniqueness: true
  validates :tracks, uniqueness: true

  def order_tracks
    self.tracks = self.tracks.sort
  end
end
