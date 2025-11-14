class SoldItem < ApplicationRecord
  belongs_to :sound_designer
  belongs_to :sfx_pack, optional: true
  belongs_to :payout, optional: true
  belongs_to :order
  monetize :amount_cents

  enum status: { pending: 0, paid: 1, failed: 2 }
  enum discount_type: { no_discount: 0, additional: 1, sale: 2 }
  enum currency: { usd: 0, eur: 1 }, _prefix: :currency
  enum payout_currency: { usd: 0, eur: 1 }, _prefix: :payout
end
