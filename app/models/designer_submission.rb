class DesignerSubmission < ApplicationRecord
  before_create :generate_password
  has_many :submission_links, dependent: :destroy

  validates :first_name, :last_name, :email, presence: true
  validate :links_count

  enum status: [:profile_created, :submited, :accepted, :rejected]

  private

  def links_count
    if submission_links.count > 5
      errors.add(:submission_links, "You must add between 1 and 5 links")
    end
  end

  def generate_password
    self.random_password = SecureRandom.alphanumeric(12)
  end
end
