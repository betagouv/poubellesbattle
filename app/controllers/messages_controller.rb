class MessagesController < ApplicationController
  require 'uri'

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.message_type == "message-membres" || @message.message_type == "message-agglo"
      redirect_to root_path and return unless current_user.referent?
    end
    if @message.save
      flash[:notice] = "Votre message a été envoyé"
    else
      flash[:alert] = "L'envoi du message n'a pas fonctionné.."
    end

    if @message.message_type == "interet-donvert"
      redirect_to donverts_path
    elsif @message.message_type == "message-membres" || @message.message_type == "message-agglo"
      redirect_to composteur_path(current_user.composteur)
    elsif @message.message_type == 'message-to-referent'
      @referent_composteur = User.find(@message.recipient_id.to_i)
      unless request.referer
        redirect_to root_path
      else
        case URI(request.referer).path
        when '/'
          redirect_to root_path
        when '/composteurs/' + @referent_composteur.composteur.id.to_s
          redirect_to composteur_path(@referent_composteur.composteur)
        end
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:recipient_id, :content, :sender_email, :sender_full_name, :message_type, :donvert_id)
  end
end
