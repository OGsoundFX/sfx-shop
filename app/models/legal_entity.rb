class LegalEntity < ApplicationRecord
  belongs_to :user
  has_many :payment_infos, dependent: :destroy

  enum status: [:pending, :incomplete, :rejected, :accepted]

  accepts_nested_attributes_for :payment_infos, allow_destroy: true

  # validation
  validates :first_name, :last_name, :street_name, :street_number, :city, :postal_code, :country, presence: true

  private

  def set_default
    self.entity_type = company_name.blank? ? 'individual' : 'company'
    self.legal_name = "#{first_name} #{last_name}"
    self.status = :pending
  end
end
