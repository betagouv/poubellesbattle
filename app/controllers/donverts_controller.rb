class DonvertsController < ApplicationController
skip_before_action :authenticate_user!

  def new
    @don = Donvert.new
  end

  def edit
  end

  def create
    @don = Donvert.new(don_params)
    @don.save
    render :index
  end

  def index
    @dons = Donvert.all
  end

  private

  def set_don
    @don = Donvert.find(params[:id])
  end

  def don_params
    params.require(:donvert).permit(:title, :type_matiere_orga, :volume_litres, :donneur_name, :donneur_address, :donneur_tel, :donneur_email, :date_fin_dispo, :description)
  end

end
