class DonvertsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_don, only: [:edit, :update, :destroy]

  def index
    @dons = Donvert.all.order(date_fin_dispo: :desc)
  end

  def new
    @don = Donvert.new
  end

  def create
    @don = Donvert.new(don_params)
    if @don.save
      redirect_to donverts_path
    else
      render :new
    end
  end

  def edit
  end

  def update

  end

  def destroy

  end

  private

  def set_don
    @don = Donvert.find_by slug: params[:slug]
  end

  def don_params
    params.require(:donvert).permit(:donateur_type, :title, :type_matiere_orga, :volume_litres, :donneur_name, :donneur_address, :donneur_tel, :donneur_email, :date_fin_dispo, :description, :photo)
  end

end
