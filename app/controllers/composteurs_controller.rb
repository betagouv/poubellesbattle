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

  def new
    @composteur = Composteur.new
  end

  def create
    @composteur = Composteur.new
    # @meal.user = current_user
    @composteur.save
    redirect_to root_path
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

# def composteur_params
#     params.require(:composteur).permit(:name, :address, :category, :bacs_number, :quantity_max, :start_availability_date, :end_availability_date, :photo)
# end

end
