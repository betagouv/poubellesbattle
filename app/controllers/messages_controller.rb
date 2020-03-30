class MessagesController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      flash[:notice] = "Votre message à été envoyé"
    else
      flash[:alert] = "L'envoi du message n'a pas fonctionné.."
    end

    if @message.message_type == "interet-donvert"
      redirect_to donverts_path
    elsif @message.message_type == "message-membres" || @message.message_type == "message-agglo"
      redirect_to composteur_path(current_user.composteur)
    elsif @message.message_type == 'message-to-referent'
      @referent_composteur = User.find(@message.recipient_id.to_i)
      redirect_to composteur_path(@referent_composteur.composteur)
    end
  end

  private

  # def set_don
  #   @don = Donvert.find(params[:don_id])
  # end

  def message_params
    params.require(:message).permit(:recipient_id, :content, :sender_email, :sender_full_name, :message_type, :donvert_id)
  end
end
