class NotificationMailer < ApplicationMailer
  def demande_referent_directe
    @notification = params[:notification]
    @composteur = Composteur.find(@notification.content.to_i)
    @referent = User.where(composteur_id: @composteur.id).referent.first
    @user = User.find(@notification.user_id)

    mail(to: @referent.email, subject: "Une nouvelle personne aimerait devenir référent•e avec vous !")
  end

  def demande_referent_state
    @notification = params[:notification]
    @state = params[:state]
    @composteur = Composteur.find(@notification.content.to_i)
    @user = User.find(@notification.user_id)

    mail(to: @user.email, subject: "Votre demande de référent sur #{@composteur.name}")
  end
end
