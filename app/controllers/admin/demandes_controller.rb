class Admin::DemandesController < ApplicationController
  before_action :user_admin?
  before_action :set_demande, only: [:show, :suivre, :edit, :update, :formulaire_toggle, :destroy]
  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def index
    @notifications = Notification.where(notification_type: "demande-référent")
    @demandes = Demande.all.order(updated_at: :desc)
    @composteurs = Composteur.all
    @users = User.all
  end

  def edit; end

  def update
    if @demande.update(demande_params_admin)
      redirect_to edit_admin_demande_path(@demande)
      flash[:notice] = "La demande de #{@demande.first_name} a bien été prise en compte."
    else
      render :edit
    end
  end

  def formulaire_toggle
    @demande.completed_form ? @demande.completed_form = false : @demande.completed_form = true

    if @demande.save
      redirect_to edit_admin_demande_path(@demande)
      flash[:notice] = @demande.completed_form ? "formulaire complet !" : "vous pouvez modifier la demande"
    else
      render :edit
      flash[:notice] = "une erreur s'est produite.."
    end
  end

  def destroy
    @demande.destroy
    redirect_to admin_demandes_path
  end

  private

  def set_demande
    @demande = Demande.find_by slug: params[:slug]
  end

  def demande_params_admin
    params.require(:demande).permit(:first_name, :last_name, :logement_type, :inhabitant_type, :potential_users, :address, :phone_number, :email, :status, :location_found, :planification_date, :completed_form, :photo, :potential_address, :notes_to_collegues)
  end
end
