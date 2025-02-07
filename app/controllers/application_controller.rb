class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_up_path_for(resource)
    redirect_back
  end

  def authenticate_admin
    # redirect_back fallback_location: root_path, alert: 'Not authorized.' unless current_user.has_role?(:admin)
    redirect_back fallback_location: root_path, alert: 'Not authorized.' unless current_user.has_role? 'admin'
  end

  def exclude_customer
    if current_user.has_role?('customer')
      redirect_to root_path, alert: 'Not authorized.' 
    end
  end

  def check_read_write
    # Admins and Staff have Read Write Access
    if ! (current_user.has_role?('admin') || current_user.has_role?('staff'))
      redirect_to root_path, alert: 'Not authorized.' 
    end
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :email, :username, :bypass_email_confirmation, :confirmed_at, role_ids: []])

    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone_number, :email, :username])
  end

end
