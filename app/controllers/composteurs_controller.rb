class ComposteursController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
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
    # @query = params[:query]
    # # @query_on_category = params[:category]

    # # if @query.present?
    #   @composteurs = Composteur.geocoded.global_search(params[:query])
    # # elsif @query_on_category.present?
    # #   categories = @query_on_category.select { |k, v| v == '1' }.keys
    # #   @meals = Meal.geocoded.select { |m| categories.include?(m.category) }
    # else
    if user_signed_in?
      if current_user.role == "admin"
        @composteurs = Composteur.includes(:photo_attachment).geocoded
      else
        @composteurs = Composteur.geocoded
      end
    else
      @composteurs = Composteur.geocoded
    end

    @composteurs_all = Composteur.includes([:photo_attachment]).all.order(created_at: :asc)
  # end

    @markers = @composteurs.includes(:photo_attachment).map do |compo|
      if compo.manual_lng.nil? || compo.manual_lat.nil?
        {
          lat: compo.latitude,
          lng: compo.longitude,
          infoWindow: render_to_string(partial: "info_window", locals: { compo: compo }),
          image_url: if compo.public == true
                       helpers.asset_url('markerpb-public.png')
                     else
                       helpers.asset_url('markerpb-prive.png')
                     end
        }
      else
        {
          lat: compo.manual_lat,
          lng: compo.manual_lng,
          infoWindow: render_to_string(partial: "info_window", locals: { compo: compo }),
          image_url: if compo.public == true
                       helpers.asset_url('markerpb-public.png')
                     else
                       helpers.asset_url('markerpb-prive.png')
                     end
        }
      end
    end
  end

  def show
    @composteur = Composteur.find(params[:id])
    @composteur.date_retournement ? @time_left = (@composteur.date_retournement - Date.today).round : @time_left = 300
    # users du composteur = les referents + les utilisateurs non referents
    @users = @composteur.users # tous les utilisateurs du site
    # @unsorted_users = @composteur.users.order(role: :asc) # tous les utilisateurs du site

    @referents = @users.where(role: "référent").order(ok_mail: :asc).order(ok_phone: :asc) # les referents du composteur
    @reversed_referents = @users.where(role: "référent").order(ok_mail: :asc).order(ok_phone: :asc).sort_by { |user| user.notifications.count }.reverse! # les referents du composteur
    @not_referents = @users.where(role: nil).sort_by { |user| user.notifications.count }.reverse! # les non-referents

    if user_signed_in?
      @future_users = User.where(composteur_id: nil)
      if params[:query].present?
        @users_search = @future_users.search_by_first_name_and_last_name(params[:query])
      else
        @users_search = []
      end
      @message = Message.new
      @notification = Notification.new
      @last_anomalie = @composteur.notifications.where(notification_type: "anomalie").last
      @depots_count = @composteur.notifications.where(notification_type: "depot").count
      anonymous_notifications = Notification.where(composteur_id: @composteur.id).includes(:user)
      non_anonymous_notifications = @composteur.notifications.includes(:user)
      @notifications = (anonymous_notifications + non_anonymous_notifications).sort.reverse
      # .where(notification_type: "welcome").or(@composteur.notifications.where(notification_type: "depot")).or(@composteur.notifications.where(notification_type: "depot direct")).or(@composteur.notifications.where(notification_type: "anomalie")).or(@composteur.notifications.where(notification_type: "message")).includes(:user).order(created_at: :desc).first(100)
      @score = 0
      @notifications.each do |notif|
        if notif.notification_type == "depot" || notif.notification_type == "depot direct" || (notif.notification_type == "anomalie" && !notif.resolved )
          @score += 10
        elsif notif.notification_type == "anomalie" && notif.resolved
          @score -= 5
        elsif notif.notification_type == "message"
          @score += 2
        end
      end
      @messages_notifications = @composteur.notifications.where(notification_type: "message-ref").last
      @messages_admin = Notification.where(notification_type: "message-admin").last
    end
  end

  def new
    if current_user.role == "admin"
      @composteur = Composteur.new
    else
      redirect_to root_path
    end
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

    require 'rqrcode'

    qrcode = RQRCode::QRCode.new("#{composteur_url(@composteur)}")

    # NOTE: showing with default options specified explicitly : svg as a string.
    svg_string = qrcode.as_svg(
      offset: 0,
      module_size: 6,
      standalone: false
    )
    @svg = svg_string.gsub("fill:#000", "")

    anonymous_depot_code = RQRCode::QRCode.new("#{anonymous_depot_url(composteur: @composteur.id, type: 'depot direct')}")

    # NOTE: showing with default options specified explicitly : svg as a string.
    svg_depot_string = anonymous_depot_code.as_svg(
      offset: 0,
      module_size: 4,
      standalone: false
    )
    @anonymous_depot = svg_depot_string.gsub("fill:#000", "")

    if current_user.role == "admin"
      @markers =
        [{
          id: @composteur.id,
          lat: @composteur.latitude,
          lng: @composteur.longitude,
          infoWindow: render_to_string(partial: "info_window", locals: { compo: @composteur }),
          image_url: helpers.asset_url('markerpb-grey.png')
        }]
      unless @composteur.manual_lng.nil? || @composteur.manual_lat.nil?
        @markers.push({
          lat: @composteur.manual_lat,
          lng: @composteur.manual_lng,
          infoWindow: render_to_string(partial: "info_window", locals: { compo: @composteur }),
          image_url: helpers.asset_url('markerpb-bicolor.png')

        })
      end
      @users = User.where(composteur_id: @composteur)
      if params[:query].present?
        @referents = User.search_by_first_name_and_last_name(params[:query])
      else
        @referents = @users.where(role: "référent")
      end
    else
      redirect_to composteur_path(@composteur)
    end
  end



  def new_manual_latlng
    return unless current_user.role == "admin"

    man_lng = params[:manual_lng].to_f
    man_lat = params[:manual_lat].to_f
    @composteur = Composteur.find(params[:id])
    @composteur.manual_lng = man_lng
    @composteur.manual_lat = man_lat
    if @composteur.save
      redirect_to edit_composteur_path(@composteur)
    else
      render :edit
      flash[:notice] = "Erreur : les coordonnées n'ont pas pu être enregistrées."
    end
  end

  def suppr_manual_latlng
    @composteur = Composteur.find(params[:id])
    @composteur.manual_lat = nil
    @composteur.manual_lng = nil
    if @composteur.save
      redirect_to edit_composteur_path(@composteur)
    else
      render :edit
      flash[:notice] = "Erreur : les coordonnées n'ont pas pu être effacées."
    end
  end


  def inscription_par_referent
    user = User.find(params[:user_id])
    composteur = Composteur.find(params[:id])
    user.composteur_id = composteur.id
    if user.save
      redirect_to composteur_path
      flash[:notice] = "Souhaitez la bienvenue à #{user.first_name} !"
    else
      render :show
      flash[:notice] = "Oups, une erreur s'est produite.."
    end
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
    @user.notifications.destroy_all
    @user.composteur_id = nil
    @user.role = nil
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
    demande_ref = Notification.new( content: "#{@composteur.id}", user_id: @user.id)
    if @composteur.users.where(role: "référent").count > 0
      demande_ref.notification_type = "demande-référent-directe" # send directly by email to référent
    else
      demande_ref.notification_type = "demande-référent"
    end

    if demande_ref.save!
      # a mail gets send to referents.first if referents exist && if demande-référent-directe
      redirect_to composteur_path
      flash[:notice] = "Votre demande a été envoyée"
    else
      redirect_to composteur_path
      flash[:notice] = "Votre demande n'a pas été envoyée.."
    end
  end

  def ajout_referent_composteur
    @composteur = Composteur.find(params[:id])
    @user = User.find(params[:referent_id])
    @user.composteur_id = @composteur.id
    @user.role = "référent"
    if @user.save
      redirect_to edit_composteur_path(@composteur)
    else
      render :edit
    end
  end

  def validation_referent_composteur
    notification = Notification.find(params[:id])
    @user = User.find(notification.user_id)
    @user.role = "référent"
    @user.save
    NotificationMailer.with(notification: notification, state: "validée").demande_referent_state.deliver_now
    notification.destroy
    redirect_to demandes_path
  end

  def non_referent_composteur
    if current_user.role == "admin"
      @user = User.find(params[:referent_id])
    else
      @user = current_user
    end
    @composteur = Composteur.find(params[:id])
    @user.role = nil
    if @user.save
      if current_user.role == "admin"
        redirect_to edit_composteur_path(@composteur)
        flash[:notice] = "Cet•te utilisateur•ice n'est plus référent•e."
      else
        redirect_to composteur_path
        flash[:notice] = "Vous n'êtes plus référent•e•s !"
      end
    else
      render :show
      flash[:notice] = "Oups, une erreur s'est produite.."
    end
  end

  def update
    @composteur = Composteur.find(params[:id])
    if @composteur.update(composteur_params)
      redirect_to composteur_path(@composteur)
    else
      render :edit
    end
  end

  def destroy
    @composteur = Composteur.find(params[:id])
    @composteur.destroy
    redirect_to composteurs_path
  end

  def send_email
    @composteur = Composteur.find(params[:id])
      if !@composteur.referent_email.nil?
        # ContactReferentMailer.send_request(@composteur).deliver_now
        flash[:notice] = "Demande envoyée"
      else
        flash[:notice] = "Votre demande n'a pu aboutir, le référent n'a pas renseigné d'adresse mail"
      end
    redirect_to root_path
  end

  private

  def composteur_params
    params.require(:composteur).permit(:name, :address, :category, :public, :installation_date, :status, :volume, :residence_name, :commentaire, :participants, :composteur_type, :photo, :date_retournement)
  end
end
