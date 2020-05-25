class Admin::UsersController < ApplicationController
  before_action :user_admin?

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to admin_annuaire_path, notice: 'Compte supprimé 😢.'
  end
end
