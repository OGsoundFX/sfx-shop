class DesignerSubmission < ApplicationRecord
  before_create :generate_password, :generate_access_token, :destroy_prior_submission
  has_many :submission_links, dependent: :destroy
  belongs_to :user, optional: true

  validates :first_name, :last_name, :email, presence: true
  validate :links_count
  validate :completed_submission_exists

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

  def destroy_prior_submission
    submission = DesignerSubmission.find_by(email: self.email)
    submission.destroy if submission && !submission.completed
  end

  def completed_submission_exists
    submission = DesignerSubmission.find_by(email: self.email)
    return unless submission&.completed?

    errors.add(:base, "A submission with this email already exists and is completed.
      \n Please refer to the confirmation email that was sent to you to access your profile.")
  end
end
