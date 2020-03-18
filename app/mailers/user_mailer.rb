class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user] # Instance variable => available in view
    mail(to: "admin@poubellesbattle.fr", subject: 'Bienvenue sur Poubelles Battle')
    # This will render a view in `app/views/user_mailer`!
  end
end
