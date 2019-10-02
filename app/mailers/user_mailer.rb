class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    # 引数subjectにメールの件名を設定し、送信する
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
