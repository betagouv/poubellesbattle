class DemandeMailer < ApplicationMailer
  def suivi_demande
    @demande = params[:demande]
    mail(to: @demande.email, subject: "Suivi de votre demande d'installation de site de compostage")
  end
end
