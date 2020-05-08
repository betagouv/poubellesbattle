class NotificationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :new, :create, :anonymous_depot]

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

  def anonymous_depot
    if user_signed_in?
      render :show if current_user.role == "admin"
    end
    notification = Notification.new
    composteur = Composteur.find(params[:composteur])
    notification.composteur_id = composteur.id
    notification.notification_type = params[:type]
    if user_signed_in?
      notification.user_id = current_user.id
      notification.content = "#{current_user.first_name} vient de faire un dépot !"
    else
      notification.content = "Nouveau #{params[:type]} sur #{composteur.name} !"
    end
    if notification.save
      redirect_to composteur_path(composteur)
      flash[:notice] = "Dépot enregistré !"
    else
      render :show
      flash[:alert] = "Oups, le dépot n'a pas pu être enregistré.. "
    end
  end

  def resolved
    notification = Notification.find(params[:id])
    if notification.notification_type == "anomalie"
      notification.resolved = true
      if  notification.save
        redirect_to composteur_path(notification.user.composteur)
        flash[:notice] = "Anomalie résolue !"
      else
        redirect_to composteur_path(notification.user.composteur)
        flash[:alert] = "Erreur !"
      end
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
    params.require(:notification).permit(:notification_type, :content, :composteur_id)
  end
end
