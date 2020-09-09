class DonvertsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :new, :create]
  before_action :set_don, only: [:show, :link, :pourvu, :archive]

  def index
    @message = Message.new
    @dons_count = Donvert.all.count
    @dons = Donvert.all.where(archived: false).order(pourvu: :asc).order(date_fin_dispo: :desc).includes([:photo_attachment])
    if @dons.count > 0
      @dons.each do |don|
        if don.date_fin_dispo.past?
          don.archived = true
          don.save!
        end
      end
    end
  end

  def mes_dons
    @dons = current_user.donverts.where(archived: false)
    @dons_archive = current_user.donverts.where(archived: true)
  end

  def show
    redirect_to donverts_path unless @don.user_id == current_user.id
  end

  def link
    if @don.codeword == params[:codeword]
      @don.user_id = current_user.id
      if @don.save
        redirect_to donvert_path(@don)
        flash[:notice] = "Ce don est relié à votre compte !"
      end
    else
      redirect_to donverts_path
      flash[:alert] = "Mauvais mot de passe."
    end
  end

  def new
    @don = Donvert.new
  end

  def create
    @don = Donvert.new(don_params)
    @don.user_id = current_user.id if user_signed_in?
    @don.date_fin_dispo = Date.today + 3.weeks if @don.date_fin_dispo == nil
    if @don.save
      redirect_to donverts_path
    else
      render :new
    end
  end

  def pourvu
    redirect_to donverts_path and return unless current_user.id == @don.user_id
    @don.pourvu = true
    @don.save
    redirect_to donverts_path
    flash[:notice] = "Votre don est pourvu. L'annonce reste visible mais votre mail n'est plus accessible."
  end

  def archive
    redirect_to donverts_path and return unless current_user.id == @don.user_id
    @don.archived = true
    @don.save
    redirect_to donverts_path
    flash[:notice] = "Votre don est archivé. Il n'apparaîtra plus dans la Bourse Verte."
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
