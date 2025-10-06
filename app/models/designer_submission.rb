class DesignerSubmission < ApplicationRecord
  before_create :generate_password, :generate_access_token
  has_many :submission_links, dependent: :destroy
  belongs_to :user, optional: true

  validates :first_name, :last_name, :email, presence: true
  validate :links_count

  enum status: [:profile_created, :submited, :accepted, :rejected]

  def to_param
    access_token
  end

  private

  def links_count
    if submission_links.count > 5
      errors.add(:submission_links, "You must add between 1 and 5 links")
    end
  end

  def generate_password
    self.random_password = SecureRandom.alphanumeric(12)
  end

  def generate_access_token
    self.access_token = SecureRandom.hex(20)
  end
end
