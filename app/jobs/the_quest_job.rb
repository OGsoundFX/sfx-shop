class TheQuestJob < ApplicationJob
  queue_as :default

  require "net/http"
  require "uri"

  def perform
    uri = URI("https://the-quest.onrender.com/")

    Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 60) do |http|
      request = Net::HTTP::Get.new(uri)
      response = http.request(request)

      Rails.logger.info(
        "[TheQuestJob] Pinged Render app: #{response.code}"
      )
    end
  rescue StandardError => e
    Rails.logger.error("[TheQuestJob] Ping failed: #{e.message}")
  end
end
