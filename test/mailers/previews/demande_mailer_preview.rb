class DemandeMailerPreview < ActionMailer::Preview
  def new_demande
    demande = Demande.last

    DemandeMailer.with(demande: demande).new_demande
  end

  def refus_demande
    demande = Demande.last

    DemandeMailer.with(demande: demande).refus_demande
  end

  def planification_demande
    demande = Demande.last

    DemandeMailer.with(demande: demande).planification_demande
  end
end
