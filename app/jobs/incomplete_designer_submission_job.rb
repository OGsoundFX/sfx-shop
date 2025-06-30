class IncompleteDesignerSubmissionJob < ApplicationJob
  queue_as :default

  def perform(*args)
    incomplete_submissions = DesignerSubmission.profile_created
    incomplete_submissions.each do |submission|
      DesignerMailer.incomplete_submission(submission).deliver_later
    end
  end
end
