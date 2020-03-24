class DonvertsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :new, :create]
  before_action :set_don, only: [:show, :link, :edit, :pourvu, :archive, :update, :destroy]

  def index
    @dons_count = Donvert.all.count
    @dons = Donvert.all.where(archived: false).order(pourvu: :asc).order(date_fin_dispo: :desc).includes([:photo_attachment])
  end

  def show
    if @don.user_id != nil && @don.user_id != current_user.id
      redirect_to donverts_path
      flash[:alert] = "Ce don est déjà associé à un autre compte."
    end
  end

  def link
    if @don.codeword == params[:codeword]
      @don.user_id = current_user.id
      if @don.save
        redirect_to donvert_path(@don)
        flash[:notice] = "Ce don est relié à votre compte !"
      end
    else
      redirect_to donvert_path(@don)
      flash[:alert] = "Mauvais mot de passe."
    end
  end

  def new
    @don = Donvert.new
  end

  def create
    @don = Donvert.new(don_params)
    if user_signed_in?
      @don.user_id = current_user.id
    end
    if @don.save
      redirect_to donverts_path
    else
      render :new
    end
  end

  def edit
  end

  def pourvu
    @don.pourvu = true
    @don.save
    redirect_to donvert_path(@don)
  end

  def archive
    @don.archived = true
    @don.save
    redirect_to donvert_path(@don)
  end

  def update
    @don.update(don_params)
    if @don.save
      redirect_to donverts_path
    else
      render :show
    end
  end

  def destroy
  end

  private

  def set_don
    @don = Donvert.find_by slug: params[:slug]
  end

  def don_params
    params.require(:donvert).permit(:donateur_type, :title, :type_matiere_orga, :volume_litres, :donneur_name, :donneur_address, :donneur_tel, :donneur_email, :date_fin_dispo, :description, :photo, :pourvu)
  end
end
