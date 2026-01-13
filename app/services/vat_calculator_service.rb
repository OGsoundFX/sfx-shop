module VatCalculatorService
  def self.vat_amount(price, vat = 0.19)
    (price / (1 + vat)) * vat
  end
end
