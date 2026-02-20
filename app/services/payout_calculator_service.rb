class PayoutCalculatorService
  def self.call(amount)
    vat_rate = 0.19
    payout_rate = 0.8
    net = amount / (1 + vat_rate)
    (net * payout_rate).round(2)
  end
end
