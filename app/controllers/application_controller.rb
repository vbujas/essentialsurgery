class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
 
def layout_by_resource
  if devise_controller? && resource_name == :user && action_name == 'sign_in'
    'devise'
  else
    'application'
  end
  end

  def after_sign_in_path_for(resource)
    if current_user.admin?
      doctors_path
    else
      edit_doctor_path(current_user.doctor.id)
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

  def configure_permitted_parameters

    #    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_up,   keys: [:username, :email, :password, :password_confirmation, :remember_me])  
    devise_parameter_sanitizer.permit(:sign_in,   keys: [:username, :password, :remember_me])  
    devise_parameter_sanitizer.permit(:account_update,   keys: [:username, :password, :password_confirmation, :current_password])  
  end
end
