class NotificationMailer < ApplicationMailer
  def demande_referent_directe
    @notification = params[:notification]
    @composteur = Composteur.find(@notification.content.to_i)
    @referent = User.where(composteur_id: @composteur.id).where(role: "référent").first
    @user = User.find(@notification.user_id)

    mail(to: @referent.email, subject: "Une nouvelle personne aimerait devenir référent•e avec vous !")
  end
end
