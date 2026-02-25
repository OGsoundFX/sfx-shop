class SentEmail < ApplicationRecord
  before_validation :default_values, on: :create
  belongs_to :prospect
  enum response_type: { no_response: 0, positive: 1, negative: 2 }

  private

  def default_values
    self.responded ||= false
    self.response_type ||= :no_response
  end
end
