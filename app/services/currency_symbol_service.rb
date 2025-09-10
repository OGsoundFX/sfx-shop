module CurrencySymbolService
  def self.call
    {
      "$" => "usd",
      "€" => "eur",
      "eur" => "€",
      "usd" => "$"
    }
  end

  # possibly translate to the following (constant + lookup method)

  #   MAP = {
  #   "$"  => "usd",
  #   "€"  => "eur",
  #   "usd" => "$",
  #   "eur" => "€"
  # }.freeze

  # def self.lookup(value)
  #   MAP[value]
  # end
end
