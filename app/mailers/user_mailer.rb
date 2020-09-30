class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user] # Instance variable => available in view
    mail(to: @user.email, subject: 'Bienvenue sur Voisins de Compost !')
    # This will render a view in `app/views/user_mailer`!
  end
end
