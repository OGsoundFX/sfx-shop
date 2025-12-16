class PaymentInfo < ApplicationRecord
  belongs_to :sound_designer

  validates :paypal_account, :preferred_currency, presence: true

  enum status: {unknown: 0, pending_verif: 1, active: 2, inactive: 3}
  enum preferred_method: {paypal: 0, bank_transfer: 1}
  enum preferred_currency: {usd: 0, eur: 1}
end
