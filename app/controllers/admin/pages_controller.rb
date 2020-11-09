class Admin::PagesController < ApplicationController
  require 'csv'
  before_action :user_admin?
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

  def annuaire
    @composteurs = Composteur.all
    @users = User.all.order(created_at: :desc)
    if params[:query].present?
      @users_list = @users.search_by_first_name_and_last_name(params[:query])
    else
      @users_list = @users
    end
  end

  def users_export
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv }
    end
  end

  def users_newsletter
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv_newsletter }
    end
  end
end
