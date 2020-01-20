class DemandesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def index
    @demandes = Demande.all.order(updated_at: :desc)
  end

  def show
    @demande = Demande.find(params[:id])
  end

  def new
    @demande = Demande.new
  end

  def create
    @demande = Demande.new(demande_params)
    if @demande.save
      redirect_to root_path
      flash[:notice] = "Demande envoyée"
    else
      render :new
      flash[:notice] = "Votre demande n'a pu aboutir, le référent n'a pas renseigné d'adresse mail"
    end
  end

  def edit
    @demande = Demande.find(params[:id])
  end

  def update
    @demande = Demande.find(params[:id])
    if @demande.update(demande_params_admin)
      redirect_to demandes_path
    else
      render :edit
    end
  end

  def destroy
    @demande = Demande.find(params[:id])
    @demande.destroy
    redirect_to demandes_path
  end

  private

  def demande_params
    params.require(:demande).permit(:first_name, :last_name, :logement_type, :inhabitant_type, :potential_users, :address, :phone_number, :email)
  end

  def demande_params_admin
    params.require(:demande).permit(:first_name, :last_name, :logement_type, :inhabitant_type, :potential_users, :address, :phone_number, :email, :status, :location_found, :planification_date)
  end
end
