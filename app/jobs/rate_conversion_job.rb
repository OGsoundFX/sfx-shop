class RateConversionJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
  end
end
require "open-uri"
require "json"

class RateConversionJob < ApplicationJob
  queue_as :default

  def perform(*args)
    url = "https://api.exchangerate.host/live?access_key=#{ENV['EXCHANGE_RATE_API_KEY']}&currencies=EUR"
    # eur_usd_url ="https://api.exchangerate.host/live?access_key=#{ENV['EXCHANGE_RATE_API_KEY']}&source=EUR&currencies=USD"

    response = JSON.parse(URI.open(url).read)

    usd_eur_rate = response["quotes"]["USDEUR"]
    eur_usd_rate = 1 / usd_eur_rate

    if response["success"]
      CurrencyRate.create!(
        base: "USD",
        target: "EUR",
        rate: usd_eur_rate
      )
      CurrencyRate.create!(
        base: "EUR",
        target: "USD",
        rate: eur_usd_rate
      )
    end

    # if else statement:
    # if response succesful store a new conversion rate
    # else use the last one in DB

    # store both api response rate and inverse calculated rate

    # perform this job daily at midnight or something
  end
end
