class UserMailerPreview < ActionMailer::Preview
  def welcome
    user = User.last
    # This is how you pass value to params[:user] inside mailer definition!
    UserMailer.with(user: user).welcome.deliver_now
  end
end
