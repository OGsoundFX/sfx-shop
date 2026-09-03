class AdminMailer < ApplicationMailer
  def new_designer_submission(submission)
    emails = User.where(admin: true).pluck(:email)
    @designer_submission = submission
    mail(to: emails, subject: "New seller submission to BamSFX!")
  end
end
