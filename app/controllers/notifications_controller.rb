class NotificationsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    # @notifications = Notification.where(composteur == composteur_id).last(5)
    # @notifications = Notification.where(User.find(user_id).id == User.where(Composteur.find())
    @notifications = @composteur.notifications
  end

  def show
  end

  def new
  end

  def create
  end
end
