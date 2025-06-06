class SfxPack < ApplicationRecord
  belongs_to :sound_designer
  has_many :orders, dependent: :destroy
  has_many_attached :photos, dependent: :destroy
  has_one_attached :banner
  monetize :price_cents

  def to_param
    "#{id} #{title}".parameterize
  end
end
