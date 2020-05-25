class Admin::DonvertsController < ApplicationController
  before_action :user_admin?

  def destroy
    donvert = Donvert.find_by slug: params[:slug]
    donvert.destroy
    redirect_to donverts_path, notice: "Offre de don supprimée 🤷‍♀️"
  end
end
