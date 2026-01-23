class UserMailer < ApplicationMailer
  def cart_reminder(user, sale)
    @user = user
    @sale = sale
    email = user.email
    mail(to: email, subject: "You have some items in your Cart")
  end
end
