class PayoutCalculatorService
  VAT_RATES = {
  "DE": 0.19,
  "FR": 0.20,
  "IT": 0.22,
  "ES": 0.21,
  "NL": 0.21,
  "BE": 0.21,
  "PL": 0.23,
  "SE": 0.25,
  "AT": 0.20,
  "PT": 0.23,
  "IE": 0.23,
  "GR": 0.24,
  "CZ": 0.21,
  "HU": 0.27,
  "SK": 0.20,
  "SI": 0.22,
  "LT": 0.21,
  "LV": 0.21,
  "EE": 0.20,
  "FI": 0.24,
  "DK": 0.25,
  "RO": 0.19,
  "BG": 0.20,
  "HR": 0.25,
  "LU": 0.17,
  "MT": 0.18,
  "CY": 0.19,
  "GB": 0.20,
  "CH": 0.077,
  "NO": 0.25,
  "IS": 0.24,
  "LI": 0.077,
  "AU": 0.10,
  "JP": 0.10,
  "NZ": 0.15,
  "SG": 0.09,
  "KR": 0.10,
  "CA": 0.05,
  "US": 0.00,
  "BR": 0.00,
  "IN": 0.00,
  "ZA": 0.15,
  "TR": 0.20,
  "RU": 0.20,
  "MX": 0.16,
  "AR": 0.21,
  "CL": 0.19,
  "CO": 0.19,
  "PE": 0.18,
  "VN": 0.10,
  "TH": 0.07,
  "ID": 0.11,
  "PH": 0.12,
  "MY": 0.08,
  "SA": 0.15,
  "AE": 0.05,
  "QA": 0.00,
  "IL": 0.17,
  "default": 0.19
  }
  def self.call(amount, location)
    vat_rate = VAT_RATES[location&.to_sym] || VAT_RATES[:default]
    p vat_rate
    payout_rate = 0.8
    net = amount / (1 + vat_rate)
    (net * payout_rate).round(2)
  end

  def self.vat_rate_for_location(location)
    VAT_RATES[location&.to_sym] || VAT_RATES[:default]
  end

  def self.vat_amount(amount, location)
    vat_rate = vat_rate_for_location(location)
    (amount - (amount / (1 + vat_rate))).round(2)
  end
end
