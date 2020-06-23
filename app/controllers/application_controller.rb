class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :ensure_domain


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

  def ensure_domain
    if Rails.env.production?
      if request.env['HTTP_HOST'] != 'poubellesbattle.fr'
        redirect_to "https://poubellesbattle.fr", status: 301
      end
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :role, :composteur_id, :photo, :ok_phone, :ok_mail, :ok_newsletter])
  end

  def after_sign_in_path_for(resource)
    # return the path based on resource
    case resource.role
    when "admin"
      admin_composteurs_path
    when "referent"
      composteur_path(resource.composteur)
    else
      resource.composteur.nil? ? root_path : composteur_path(resource.composteur)
    end
  end
end
