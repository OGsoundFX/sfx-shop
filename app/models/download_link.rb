class DownloadLink < ApplicationRecord
  belongs_to :collection, optional: true
  belongs_to :order

  before_validation :generate_token, on: :create

  validates :token, presence: true, uniqueness: true
  validates :url, presence: true
  validates :validity_duration, presence: true

  def expired?
    created_at + validity_duration > 1
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(32)
  end
end
