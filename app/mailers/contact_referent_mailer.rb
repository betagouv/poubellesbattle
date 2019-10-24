class ContactReferentMailer < ApplicationMailer

  # def askaccess(referent)
  #   @referent = referent
  #   mail to: @referent.email, subject: "Vous avez reçu une demande d'accès au composteur collectif"
  # end

  def send_request(composteur)
    @composteur = composteur

    mail(
          :subject => 'Vous avez reçu une demande d acces',
          :cc => 'jennifer.stephan@beta.gouv.fr',
          :from => 'jennifer@mae.com',
          :track_opens => 'true'
        )

    mail to: @composteur.referent_email
  end

end
