class DesignerSubmission < ApplicationRecord
  has_many :submission_links, dependent: :destroy
  # accepts_nested_attributes_for :submission_links, allow_destroy: true

  validates :first_name, :last_name, :email, presence: true
  validate :links_count

  enum status: [:profile_created, :submited, :accepted, :rejected]

  private

  def links_count
    if submission_links.count > 5
      errors.add(:submission_links, "You must add between 1 and 5 links")
    end
  end
end
