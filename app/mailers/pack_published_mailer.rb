class PackPublishedMailer < ApplicationMailer
  def approved(sfx_pack)
    @sfx_pack = sfx_pack
    @designer = sfx_pack.sound_designer
    email = sfx_pack.sound_designer.user.email
    mail(to: email, subject: "Your #{sfx_pack.title} Sound Effects Pack has been approved!")
  end

  def rejected(sfx_pack)
    @sfx_pack = sfx_pack
    @designer = sfx_pack.sound_designer
    email = sfx_pack.sound_designer.user.email
    mail(to: email, subject: "Your #{sfx_pack.title} Sound Effects Pack has been rejected.")
  end
end
