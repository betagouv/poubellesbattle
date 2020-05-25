class Admin::ComposteursController < ApplicationController
  before_action :user_admin?
  before_action :set_composteur, only: [:edit, :update, :destroy]

  def index
    @composteurs = Composteur.includes(:photo_attachment).geocoded

    @composteurs_count = Composteur.count
    @composteurs_all = Composteur.all

    @message = Message.new
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
    require 'rqrcode'

    qrcode = RQRCode::QRCode.new("#{composteur_url(@composteur)}")
    # @message = Message.new
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
      @referents = @users.referent
    end
  end

  def update
    if @composteur.update(composteur_params)
      redirect_to composteur_path(@composteur)
    else
      render :edit
    end
  end

  def destroy
    @composteur.destroy
    redirect_to composteurs_path
  end

  def new_manual_latlng
    man_lng = params[:manual_lng].to_f
    man_lat = params[:manual_lat].to_f
    @composteur = Composteur.find(params[:id])
    @composteur.manual_lng = man_lng
    @composteur.manual_lat = man_lat
    if @composteur.save
      redirect_to edit_admin_composteur_path(@composteur)
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
      redirect_to edit_admin_composteur_path(@composteur)
    else
      render :edit
      flash[:notice] = "Erreur : les coordonnées n'ont pas pu être effacées."
    end
  end

  def ajout_referent_composteur
    @composteur = Composteur.find(params[:id])
    @user = User.find(params[:referent_id])
    @user.composteur_id = @composteur.id
    @user.referent!
    if @user.save
      redirect_to edit_admin_composteur_path(@composteur)
    else
      render :edit
    end
  end
  def non_referent_composteur
    @user = User.find(params[:referent_id])
    @composteur = Composteur.find(params[:id])
    @user.compostophile!
    if @user.save
      redirect_to edit_admin_composteur_path(@composteur)
      flash[:notice] = "Cet•te utilisateur•ice n'est plus référent•e."
    else
      render :show
      flash[:notice] = "Oups, une erreur s'est produite.."
    end
  end

  private

  def set_composteur
    @composteur = Composteur.find(params[:id])
  end

  def composteur_params
    params.require(:composteur).permit(:name, :address, :category, :public, :installation_date, :status, :volume, :residence_name, :commentaire, :participants, :composteur_type, :photo, :date_retournement)
  end
end
