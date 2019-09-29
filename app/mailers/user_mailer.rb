class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    # 引数subjectにメールの件名を設定し、送信する
    mail to: user.email, subject: "Account activation"
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
