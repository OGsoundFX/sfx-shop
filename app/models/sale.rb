class Sale < ApplicationRecord
  validates :percentage, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }

  def amount_earned
    Order.where("created_at >= ? AND created_at <= ?", self.start_date, self.end_date).where(status: "paid").sum(&:amount_cents).to_f
  end
end
