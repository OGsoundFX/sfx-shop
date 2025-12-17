class PaymentInfo < ApplicationRecord
  after_create_commit :payment_info_pending

  belongs_to :legal_entity

  validates :paypal_account, :preferred_currency, presence: true

  enum status: {unknown: 0, pending_verif: 1, active: 2, inactive: 3}
  enum preferred_method: {paypal: 0, bank_transfer: 1}
  enum preferred_currency: {usd: 0, eur: 1}

  private

  def payment_info_pending
    self.pending_verif!
  end
end
