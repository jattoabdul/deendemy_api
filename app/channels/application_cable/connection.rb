module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.uid
    end

    protected

    def find_verified_user # this checks whether a user is authenticated by passing user uid
      user = User.find_by_uid(uid)

      if user = User.find_by_uid(request.params[:uid])
        user
      else          
        reject_unauthorized_connection
      end 
    end
  end
end
