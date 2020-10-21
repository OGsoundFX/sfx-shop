class Order < ApplicationRecord
  belongs_to :user
  belongs_to :sfx_pack
  monetize :amount_cents
end
