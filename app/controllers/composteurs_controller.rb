class ComposteursController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    # @query = params[:query]
    # # @query_on_category = params[:category]

    # # if @query.present?
    #   @composteurs = Composteur.geocoded.global_search(params[:query])
    # # elsif @query_on_category.present?
    # #   categories = @query_on_category.select { |k, v| v == '1' }.keys
    # #   @meals = Meal.geocoded.select { |m| categories.include?(m.category) }
    # else
    @composteurs = Composteur.geocoded
  # end

    @markers = @composteurs.map do |compo|
      {
        lat: compo.latitude,
        lng: compo.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { compo: compo })
      }
    end
  end

  def show
    @composteur = Composteur.find(params[:id])
    @users = @composteur.users
    @notifications = @composteur.notifications.order(created_at: :desc)
  end

  def new
    @composteur = Composteur.new
  end

  def create
    @composteur = Composteur.create(composteur_params)
    if @composteur.save
      redirect_to root_path
    else
      render :new
    end
  end

  def send_email
    @composteur = Composteur.find(params[:id])
      if !@composteur.referent_email.nil?
        ContactReferentMailer.send_request(@composteur).deliver_now
        flash[:notice] = "Demande envoyée"
      else
        flash[:notice] = "Votre demande n'a pu aboutir, le référent n'a pas renseigné d'adresse mail"
      end
    redirect_to root_path
  end

  private

  def composteur_params
    params.require(:composteur).permit(:name, :address, :category, :public, :installation_date, :status, :volume, :residence_name, :commentaire, :participants, :composteur_type, :photo)
  end
end
