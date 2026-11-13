# app/controllers/feeds_controller.rb
require "csv"

class FeedsController < ApplicationController
  def google
    send_data generate_csv, type: "text/csv", filename: "bamsfx_feed.csv"
  end

  private

  def generate_csv
    CSV.generate(col_sep: "\t") do |csv|
      csv << %w[id title description link image_link availability price condition product_type identifier_exists]

      SfxPack.where(status: :live).find_each do |pack|
        csv << [
          pack.sku.presence || pack.id,
          pack.title,
          pack.summary.presence || pack.description,
          "https://www.bamsfx.com/sfx_packs/#{pack.id}-#{pack.title.parameterize}",
          pack.photos.first&.url || "https://bamsfx-general-content.s3.eu-central-1.amazonaws.com/banner_screenshot.png",
          "in_stock",
          "#{format_price(pack.price_cents)} #{pack.currency.upcase}",
          "new",
          "Digital Products > Audio > Sound Effects > #{pack.category.split(',').first.strip}",
          "no"
        ]
      end
    end
  end

  def format_price(cents)
    format("%.2f", cents / 100.0)
  end
end
