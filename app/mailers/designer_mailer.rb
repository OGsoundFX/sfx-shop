class DesignerMailer < ApplicationMailer
  def incomplete_submission(submission)
    email = submission.email
    @designer = submission
    mail(to: email, subject: "Your seller submission to BamSFX is incomplete!")
  end

  def submission_completed(legal_entity)
    email = legal_entity.user.email
    @designer = legal_entity.user.sound_designer
    mail(to: email, subject: "Your Seller Profile is under review!")
  end

  def submission_accepted(submission)
    email = submission.email
    @designer = submission
    mail(to: email, subject: "Your submission to BamSFX has been Accepted!")
  end

  def you_made_a_sale(sold_item)
    email = sold_item.sound_designer.user.email
    @sold_item = sold_item
    @designer = sold_item.sound_designer
    @sfx_pack = sold_item.sfx_pack
    mail(to: email, subject: "Congratulations, you've just made a sale!")
  end
end
