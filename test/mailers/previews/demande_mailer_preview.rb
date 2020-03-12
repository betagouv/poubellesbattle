class DemandeMailerPreview < ActionMailer::Preview
  def suivi_demande
    demande = Demande.last

    DemandeMailer.with(demande: demande).suivi_demande
  end
end
