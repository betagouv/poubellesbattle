class NotificationsController < ApplicationController
  # skip_before_action :authenticate_user!

  def index
    # @notifications = Notification.where(composteur == composteur_id).last(5)
    # @notifications = Notification.where(User.find(user_id).id == User.where(Composteur.find())
    @notifications = Notification.where(notification_type: "message-admin")
    @notification_last = @notifications.last
    @notification = Notification.new

  end

  def show

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
      render :new
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
