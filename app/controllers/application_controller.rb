class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
   before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    signup_attr = [:email, :password, :password_confirmation, :first_name, :last_name, :country, :zip, :state, :city, :street, roles: %i()]
    devise_parameter_sanitizer.permit(:sign_up, keys: signup_attr)
  end
end
