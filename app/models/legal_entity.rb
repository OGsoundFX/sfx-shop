class LegalEntity < ApplicationRecord
  before_validation :set_default, on: :create

  belongs_to :user
  has_one :sound_designer, through: :user
  has_many :payment_infos, dependent: :destroy
  has_many :payouts
  has_many :agreement_acceptances, dependent: :destroy
  has_many :agreements, through: :agreement_acceptances

  enum status: [:pending, :incomplete, :rejected, :accepted]
  enum entity_type: [:individual, :company]

  accepts_nested_attributes_for :payment_infos, allow_destroy: true

  # validation
  validates :first_name, :last_name, :street_name, :street_number, :city, :postal_code, :country, presence: true

  def address
    "#{street_number} #{street_name},\n#{address_line_2.present? ? address_line_2 + ', ' : ''}#{city}, #{state.present? ? state + ', ' : ''}#{postal_code},\n#{ISO3166::Country[country].iso_short_name}"
  end

  private

  def set_default
    self.entity_type = company_name.blank? ? 'individual' : 'company'
    self.legal_name = "#{first_name} #{last_name}"
    self.status ||= :pending
  end
end
