class Sale < ApplicationRecord
  def amount_earned
    Order.pluck(:sales, :amount_cents).select { |order| order[0] != {}}.select { |sale| sale[0].values[0][self.title] }.sum { |sale| sale[1] }
  end
end
