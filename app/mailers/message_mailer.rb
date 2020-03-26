class MessageMailer < ApplicationMailer
  def interest_don
    @message = params[:message]
    mail(to: @message.donvert.donneur_email, subject: "Votre proposition de don attire l'attention !")
  end
end
