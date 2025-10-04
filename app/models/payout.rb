class Payout < ApplicationRecord
  belongs_to :sound_designer
  has_many :sold_items, dependent: :nullify
  monetize :amount_cents

  enum status: { pending: 0, paid: 1, failed: 2 }
  enum currency: { usd: 0, eur: 1 }
end
