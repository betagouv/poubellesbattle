class NotificationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:anonymous_depot]
  before_action :user_referent?, only: [:show, :resolved, :destroy]

  def show
    if current_user.composteur_id == Notification.find(params[:id]).content.to_i || current_user.admin?
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
      redirect_to composteur_path(@user.composteur, anchor: 'messagerie-board')
    else
      redirect_to composteur_path(@user.composteur)
    end
    flash[:alert] = "Le message n'a pas pu être enregistré."
  end

  def anonymous_depot
    if user_signed_in?
      render :show if current_user.admin?
    end
    notification = Notification.new
    composteur = Composteur.find_by slug: params[:slug]
    notification.composteur_id = composteur.id
    notification.notification_type = params[:type]
    if user_signed_in?
      notification.user_id = current_user.id
      notification.content = "#{current_user.first_name} vient de faire un dépot !"
    else
      notification.content = "Nouveau dépot masqué 🦸 sur #{composteur.name} !"
    end
    if notification.save
      redirect_to composteur_path(composteur.slug)
      flash[:notice] = "Dépot enregistré !"
    else
      render :show
      flash[:alert] = "Oups, le dépot n'a pas pu être enregistré.. "
    end
  end

  def resolved
    notification = Notification.find(params[:id])
    if notification.notification_type == "anomalie" && current_user.composteur == notification.user.composteur
      notification.resolved = true
      if notification.save
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
    if @notification.notification_type == "demande-référent-directe"
      NotificationMailer.with(notification: @notification, state: "refusée").demande_referent_state.deliver_now
      @notification.destroy
      flash[:notice] = "Notification supprimée"
    end
    redirect_to composteur_path(@notification.composteur || @notification.user.composteur)
  end

  private

  def notification_params
    params.require(:notification).permit(:notification_type, :content)
  end
end
