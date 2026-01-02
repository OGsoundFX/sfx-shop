class Agreement < ApplicationRecord
  has_rich_text :body
  # has_one_attached :pdf, service: :cloudinary_contract_templates
  has_one_attached :pdf, service: Rails.env.production? ? :aws_s3_contract_templates : :cloudinary_contract_templates
end
