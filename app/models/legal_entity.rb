class LegalEntity < ApplicationRecord
  belongs_to :user
  has_many :payment_infos, dependent: :destroy
end
