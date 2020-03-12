class DemandeMailer < ApplicationMailer
  def new_demande
    @demande = params[:demande]
    mail(to: @demande.email, subject: "Votre demande de site de compostage")
  end

  def refus_demande
    @demande = params[:demande]
    mail(to: @demande.email, subject: "Refus de votre demande de site de compostage")
  end

  def planification_demande
    @demande = params[:demande]
    mail(to: @demande.email, subject: "Planification de l'installation du nouveau site de compostage")
  end
end
