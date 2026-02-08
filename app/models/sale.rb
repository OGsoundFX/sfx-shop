class Sale < ApplicationRecord
  def amount_earned
    Order.where("created_at >= ? AND created_at <= ?", self.start_date, self.end_date).where(status: "paid").sum(&:amount_cents).to_f
  end
end
