class Prospect < ApplicationRecord
  before_validation :default_onboard, on: :create
  has_many :sent_emails, dependent: :destroy
  enum priority: { low: 0, medium: 1, high: 2 }

  private

  def default_onboard
    self.onboard ||= false
  end
end
