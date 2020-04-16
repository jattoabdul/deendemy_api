module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.email
    end

    protected

    def find_verified_user # this checks whether a user is authenticated with devise_token_auth
      # params = request.query_parameters()
      uid = params[:uid]
      token = params[:token]
      client_id = params[:client]

      user = User.find_by_uid(uid)

      if user && user.valid_token?(token, client_id)          
        user        
      else          
        reject_unauthorized_connection        
      end 
    end
  end
end
