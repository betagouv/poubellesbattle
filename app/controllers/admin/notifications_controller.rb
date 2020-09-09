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
    @notification.notification_type = 'message-admin'

    if @notification.save
      redirect_to admin_notifications_path
    else
      render :index
      flash[:alert] = "Le message n'a pas pu être posté."
    end
  end

  def destroy
    notification = Notification.find(params[:id])
    notification.destroy
    if notification.notification_type == "demande-référent"
      NotificationMailer.with(notification: notification, state: "refusée").demande_referent_state.deliver_now
      redirect_to admin_demandes_path
    elsif notification.notification_type == "message-admin"
      redirect_to admin_notifications_path
    else
      redirect_to composteur_path(notification.composteur || notification.user.composteur)
    end
    flash[:notice] = "Notification supprimée"
  end

  private

  def notification_params
    params.require(:notification).permit(:notification_type, :content)
  end
end
