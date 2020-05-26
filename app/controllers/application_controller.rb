class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  private

  def user_admin?
    if user_signed_in?
      redirect_to root_path unless current_user.admin?
    else
      redirect_to root_path
    end
  end

  def user_referent?
    if user_signed_in?
      redirect_to root_path unless current_user.admin? || current_user.referent?
    else
      redirect_to root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :role, :composteur_id, :photo, :ok_phone, :ok_mail, :ok_newsletter])
  end

  def after_sign_in_path_for(resource)
    # return the path based on resource
    if resource.admin?
      redirect_to admin_composteurs_path
    else
      redirect_to root_path
    end
  end
end
