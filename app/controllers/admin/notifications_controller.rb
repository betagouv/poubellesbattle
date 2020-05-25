class Admin::NotificationsController < ApplicationController
  before_action :user_admin?

  def index
    @notifications = Notification.where(notification_type: "message-admin")
    @notification_last = @notifications.last
    @notification = Notification.new
  end

  def create
    @notification = Notification.create(notification_params)
    @user = current_user
    @notification.user_id = @user.id

    if @notification.save
      redirect_to notifications_path
    else
      render :index
      flash[:alert] = "Le message n'a pas pu être enregistré."
    end
  end

  def destroy
    @notification = Notification.find(params[:id])
    if @notification.notification_type == "demande-référent" || @notification.notification_type == "demande-référent-directe"
      NotificationMailer.with(notification: @notification, state: "refusée").demande_referent_state.deliver_now
    end
    @notification.destroy
    redirect_back(fallback_location: demandes_path)
    flash[:notice] = "Notification supprimée"
  end

  private

  def notification_params
    params.require(:notification).permit(:notification_type, :content)
  end
end
