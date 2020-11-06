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
    @notification.user = current_user
    @notification.composteur = current_user.composteur if current_user.composteur != nil

    if @notification.save
      redirect_to composteur_path(current_user.composteur, anchor: 'messagerie-board')
      if @notification.notification_type == 'signaler-contenu'
        flash[:notice] = 'Signalement pris en compte'
        NotificationMailer.with(notification: @notification).signaler_contenu.deliver_now
        NotificationMailer.with(notification: @notification).signaler_contenu_to_user.deliver_now
      end
    else
      redirect_to composteur_path(current_user.composteur)
      flash[:alert] = "Le message n'a pas pu être enregistré."
    end
  end

  def anonymous_depot
    if user_signed_in?
      render :show if current_user.admin?
    end
    notification = Notification.new
    # checking if params in the qr-code is ID or Slug..
    # TODO : change qr code to only show ID because slug will change..
    if params[:slug].to_i.to_s.length != params[:slug].length
      composteur = Composteur.find_by slug: params[:slug]
    else
      composteur = Composteur.find(params[:slug].to_i)
    end
    notification.composteur_id = composteur.id
    notification.notification_type = params[:type]
    if user_signed_in?
      notification.user_id = current_user.id
      notification.content = "#{current_user.first_name} vient de faire un dépot !"
    else
      notification.content = "Nouveau dépot masqué 🦸 sur #{composteur.name} !"
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
    if @notification.notification_type == "demande-référent" || @notification.notification_type == "demande-référent-directe"
      NotificationMailer.with(notification: @notification, state: "refusée").demande_referent_state.deliver_now
    end
    @notification.destroy
    redirect_to composteur_path(@notification.composteur || @notification.user.composteur)
    flash[:notice] = "Notification supprimée"
  end

  private

  def notification_params
    params.require(:notification).permit(:notification_type, :content)
  end
end
