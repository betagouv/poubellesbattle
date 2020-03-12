class NotificationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :new, :create]

  def index
    # @notifications = Notification.where(composteur == composteur_id).last(5)
    # @notifications = Notification.where(User.find(user_id).id == User.where(Composteur.find())
    @notifications = Notification.where(notification_type: "message-admin")
    @notification_last = @notifications.last
    @notification = Notification.new

  end

  def show
    if (current_user.role == "référent" && current_user.composteur_id == Notification.find(params[:id]).content.to_i) || current_user.role == "admin"
      @notification = Notification.find(params[:id])
      if @notification.notification_type == "demande-référent-directe"
        @composteur = Composteur.find(@notification.content.to_i)
        @demandeur = User.find(@notification.user_id)
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.create(notification_params)
    @user = current_user
    @notification.user_id = @user.id

    if @notification.save
      if @user.role == "admin"
        redirect_to notifications_path
      else
        redirect_to composteur_path(@user.composteur_id)
      end
    else
      if @user.role == "admin"
        redirect_to notifications_path
      else
        redirect_to composteur_path(@user.composteur_id)
        flash[:notice] = "L'anomalie ne peut pas être vide."
      end
    end
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    redirect_back(fallback_location: demandes_path)
    flash[:notice] = "Notification supprimée"
  end

  private

  def notification_params
    params.require(:notification).permit(:notification_type, :content)
  end
end
