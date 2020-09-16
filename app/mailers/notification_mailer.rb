class NotificationMailer < ApplicationMailer
  def demande_referent_directe
    @notification = params[:notification]
    @composteur = Composteur.find(@notification.content.to_i)
    @referent = User.where(composteur_id: @composteur.id).referent.first
    @user = User.find(@notification.user_id)

    mail(to: @referent.email, subject: "Une nouvelle personne aimerait devenir référent•e avec vous !")
  end

  def signaler_contenu
    @notification = params[:notification]
    @contenu_signale = Notification.find(@notification.content.to_i)
    @composteur = Composteur.find(@notification.composteur_id)

    mail(to: 'contact@poubellesbattle.fr', subject: 'Nouveau contenu signalé...')
  end

  def signaler_contenu_to_user
    @notification = params[:notification]
    @user = User.find(@notification.user_id)

    mail(to: @user.email, subject: 'Signalement de contenu pris en compte')
  end

  def demande_referent_state
    @notification = params[:notification]
    @state = params[:state]
    @composteur = Composteur.find(@notification.content.to_i)
    @user = User.find(@notification.user_id)

    mail(to: @user.email, subject: "Votre demande de référent sur #{@composteur.name}")
  end
end
