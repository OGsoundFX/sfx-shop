class IncompleteDesignerSubmissionJob < ApplicationJob
  queue_as :default

  def perform(*args)
    submission = DesignerSubmission.find_by_email("olive_girardot@hotmail.com")
    DesignerMailer.incomplete_submission(submission).deliver_now
  end
end
