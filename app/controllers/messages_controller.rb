class MessagesController < ApplicationController

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      flash[:notice] = "Votre message à été envoyé"
    else
      raise
      flash[:alert] = "L'envoi du message n'a pas fonctionné.."
    end
    redirect_to donverts_path
  end

  private

  # def set_don
  #   @don = Donvert.find(params[:don_id])
  # end

  def message_params
    params.require(:message).permit(:content, :sender_email, :sender_full_name, :donvert_id)
  end
end
