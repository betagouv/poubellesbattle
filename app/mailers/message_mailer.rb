class MessageMailer < ApplicationMailer
  def interest_don
    @message = params[:message]
    mail(to: @message.donvert.donneur_email, subject: "Votre proposition de don attire l'attention !")
  end

  def message_to_members
    @message = params[:message]
    @sender = User.where(email: @message.sender_email).first
    users_list = @sender.composteur.users
    mailing_list = []
    users_list.each do |user|
      mailing_list << user.email
    end
    mailing_string = mailing_list.join(',')
    mail(to: "voisinsdecompost@agglo-pau.fr", bcc: mailing_string, subject: "Message de #{@sender.first_name.capitalize} pour les membres de #{@sender.composteur.name}")
  end

  def message_to_agglo
    @message = params[:message]
    @sender = User.where(email: @message.sender_email).first
    mail(to: 'voisinsdecompost@agglo-pau.fr', subject: "Message de #{@sender.first_name.capitalize} - référent•e du site #{@sender.composteur.name}")
  end

  def message_to_referent
    @message = params[:message]
    @recipient = User.find(@message.recipient_id)
    mail(to: "#{@recipient.email}", subject: "#{@recipient.first_name} : #{@message.sender_full_name} vient de vous écrire.")
  end
end
