class DesignerMailer < ApplicationMailer
  def incomplete_submission(submission)
    email = submission.email
    @designer = submission
    mail(to: email, subject: "Your submission is incomplete!")
  end
end
