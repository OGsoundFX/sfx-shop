module CurrencySymbolService
  def self.call
    {
      "$" => "usd",
      "€" => "eur",
      "eur" => "€",
      "usd" => "$"
    }
  end
end
