class NotificationsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    # @notifications = Notification.where(composteur == composteur_id).last(5)
    # @notifications = Notification.where(User.find(user_id).id == User.where(Composteur.find())
    @notifications = Notification.all
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
      redirect_to composteur_path(@user.composteur_id)
    else
      render :new
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:notification_type, :content)
  end
end
