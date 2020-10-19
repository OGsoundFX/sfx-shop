class Order < ApplicationRecord
  belongs_to :user
  belongs_to :sfx_pack
  belongs_to :discount
  monetize :amount_cents
  has_one_attached :file
end
