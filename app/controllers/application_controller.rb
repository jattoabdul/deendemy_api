class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :cors_set_access_control_headers

  def cors_preflight_check
    if request.method == 'OPTIONS'
      cors_set_access_control_headers
      render plain: 'OK', content_type: 'text/plain'
    end
  end

  protected

  def cors_set_access_control_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token, Auth-Token, Email, X-User-Token, X-User-Email'
    response.headers['Access-Control-Max-Age'] = '1728000'
  end

  def configure_permitted_parameters
    signup_attr = [:email, :password, :password_confirmation, :first_name, :last_name, :country, :zip, :state, :city, :street, roles: %i()]
    devise_parameter_sanitizer.permit(:sign_up, keys: signup_attr)
  end
end
