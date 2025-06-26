class SubmissionLink < ApplicationRecord
  belongs_to :designer_submission

  validates :url, :title, presence: true
end
