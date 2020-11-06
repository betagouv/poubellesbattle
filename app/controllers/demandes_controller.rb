class DemandesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :suivre]
  invisible_captcha only: :create, on_spam: :your_spam_callback_method
  before_action :set_demande, only: [:show, :suivre, :edit, :update, :formulaire_toggle, :destroy]
  before_action :user_admin?, only: [:index, :edit, :update, :formulaire_toggle, :destroy]
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

  # page de suivi de demande de composteur (comme une show mais pas pareil)
  def suivre; end

  def new
    @demande = Demande.new
  end

  def create
    @demande = Demande.new(demande_params)
    @demande.status = "reçue"
    if @demande.save
      redirect_to suivre_path(@demande)
      flash[:notice] = "Demande envoyée"
    else
      render :new
      flash[:notice] = "Votre demande n'a pu aboutir, le référent n'a pas renseigné d'adresse mail"
    end
  end

  private

  def set_demande
    @demande = Demande.find_by slug: params[:slug]
  end

  def demande_params
    params.require(:demande).permit(:first_name, :last_name, :logement_type, :inhabitant_type, :potential_users, :address, :phone_number, :email, :photo)
  end

  def your_spam_callback_method
    redirect_to root_path
  end
end
