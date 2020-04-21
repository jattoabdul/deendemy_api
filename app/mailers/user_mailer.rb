class UserMailer < ApplicationMailer

  def welcome_email(user_id)
    @user = User.find(user_id)
    return true unless @user.present?
    @url = 'https://deendemy.com/login'
    @app_name = Deendemy::Settings.name

    mail(
      to:   %("#{@user.first_name}" <#{@user.email}>),
      subject: "Welcome To #{@app_name}!"
    )
  end
end
