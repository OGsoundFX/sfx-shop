class LegalEntity < ApplicationRecord
  belongs_to :user
  has_many :payment_infos, dependent: :destroy

  accepts_nested_attributes_for :payment_infos, allow_destroy: true
end
