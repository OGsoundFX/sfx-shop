class DesignerMailer < ApplicationMailer
  def incomplete_submission(submission)
    email = submission.email
    @designer = submission
    mail(to: email, subject: "Your seller submission to BamSFX is incomplete!")
  end
end
