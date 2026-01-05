class AgreementAcceptance < ApplicationRecord
  attr_accessor :accepted

  belongs_to :agreement
  belongs_to :legal_entity

  has_one_attached :pdf, service: Rails.env.production? ? :aws_s3_designer_contracts : :cloudinary_designer_contracts

  validates :accepted, acceptance: true
end
