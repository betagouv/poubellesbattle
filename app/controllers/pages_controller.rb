class PagesController < ApplicationController
  require 'csv'

  skip_before_action :authenticate_user!
  before_action :user_admin?
  # skip_before_action :user_admin?, only: :stats
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

  def stats
    users = User.all
    @users_count = users.count
    @users_last_month = 0
    users.each { |user| user.created_at.month < Date.today.month ? @users_last_month += 1 : @users_last_month }
  end

  def annuaire
    @composteurs = Composteur.all
    @users = User.all
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
