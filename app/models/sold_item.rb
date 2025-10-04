class SoldItem < ApplicationRecord
  belongs_to :sound_designer
  belongs_to :payout
  belongs_to :order
end
