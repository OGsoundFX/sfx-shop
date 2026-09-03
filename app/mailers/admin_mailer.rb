class AdminMailer < ApplicationMailer
  def new_designer_submission(submission)
    emails = User.where(admin: true).pluck(:email)
    @designer_submission = submission
    mail(to: emails, subject: "New seller submission to BamSFX!")
  end

  def new_designer_profile(designer)
    emails = User.where(admin: true).pluck(:email)
    @designer = designer
    mail(to: emails, subject: "New Designer Profile Submitted")
  end

  def new_pack_submission(pack)
    emails = User.where(admin: true).pluck(:email)
    @pack_submission = pack
    mail(to: emails, subject: "New pack submission to BamSFX!")
  end
end
