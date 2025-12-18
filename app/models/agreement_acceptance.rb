class AgreementAcceptance < ApplicationRecord
  belongs_to :agreement
  belongs_to :legal_entity
end
