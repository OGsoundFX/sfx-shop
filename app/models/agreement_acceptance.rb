class AgreementAcceptance < ApplicationRecord
  belongs_to :agreement
  belongs_to :legal_entity


  attr_accessor :accepted

  validates :accepted, acceptance: true
end
