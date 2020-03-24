class DonvertMailer < ApplicationMailer
  def confirmation_don
    @donvert = params[:donvert]
    mail(to: @donvert.donneur_email, subject: "Votre don est en ligne !")
  end
end
