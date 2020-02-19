class ComposteursController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

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
    @composteurs_all = Composteur.all.order(created_at: :asc)
  # end

    @markers = @composteurs.map do |compo|
      {
        lat: compo.latitude,
        lng: compo.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { compo: compo })
        # image_url: helpers.asset_url('favicon-32x32.png')
      }
    end
  end

  def show
    @composteur = Composteur.find(params[:id])
    @composteur.installation_date ? @time_left = 300 - ((Time.now - @composteur.installation_date.to_time)/86400).modulo(300).round : @time_left = 300
    # users du composteur = les referents + les utilisateurs non referents
    @users = @composteur.users # tous les utilisateurs du site
    @referents = @users.where(role: "référent") # les referents du composteur
    @not_referents = @users.where(role: "") # les non-referents

    @notification = Notification.new
    # @time_notification = Time.now - @notification.created_at

    @notifications = @composteur.notifications.where(notification_type: "welcome").or(@composteur.notifications.where(notification_type: "depot")).or(@composteur.notifications.where(notification_type: "anomalie")).or(@composteur.notifications.where(notification_type: "message")).order(created_at: :desc).first(10)
    @messages_notifications = @composteur.notifications.where(notification_type: "message-ref").last
    @messages_admin = Notification.where(notification_type: "message-admin").last
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

  def edit
    @composteur = Composteur.find(params[:id])
  end

  def inscription_composteur
    @user = current_user
    @composteur = Composteur.find(params[:id])
    @user.composteur_id = @composteur.id
    if @user.save
      redirect_to composteur_path
      flash[:notice] = "Bienvenue dans le composteur #{@composteur.name} !"
    else
      render :show
      flash[:notice] = "Oups, une erreur s'est produite.."
    end
  end

  def desinscription_composteur
    @user = current_user
    @composteur = Composteur.find(params[:id])
    # supprimer les messages quand on quitte un composteur ? Mieux, non ?
    # @user.notifications = nil
    @user.composteur_id = nil
    if @user.save
      redirect_to composteur_path
      flash[:notice] = "Vous n'êtes plus inscrit à ce composteur, vous pouvez maintenant vous inscrire à un autre !"
    else
      render :show
      flash[:notice] = "Oups, une erreur s'est produite.."
    end
  end

  def referent_composteur
    @user = current_user
    @composteur = Composteur.find(params[:id])
    @user.role = "référent"
    if @user.save
      redirect_to composteur_path
      flash[:notice] = "Bravo ! Vous êtes maintenant référent du composteur #{@composteur.name} !"
    else
      render :show
      flash[:notice] = "Oups, une erreur s'est produite.."
    end
  end

  def non_referent_composteur
    @user = current_user
    @composteur = Composteur.find(params[:id])
    @user.role = nil
    if @user.save
      redirect_to composteur_path
      flash[:notice] = "Vous n'êtes plus référent !"
    else
      render :show
      flash[:notice] = "Oups, une erreur s'est produite.."
    end
  end

  def update
    @composteur = Composteur.find(params[:id])
    if @composteur.update(composteur_params)
      redirect_to composteur_path
    else
      render :edit
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
