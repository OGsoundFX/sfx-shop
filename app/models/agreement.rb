class Agreement < ApplicationRecord
  has_rich_text :body
  # has_one_attached :pdf, service: :cloudinary_contract_templates
  # has_one_attached :pdf, service: :aws_s3_contract_templates
  has_one_attached :pdf, service: :contract_templates
end
