module Api::V1::Permissionable
  extend ActiveSupport::Concern

  included do
    before_action :check_permission
  end

  def permissions
    {
      categories: {
        admin: [ :index, :create, :show, :update, :destroy ],
        support: [ :index, :create, :show, :update ],
        tutor: [ :index, :show ],
        learner: [ :index, :show ]
      }
    }
  end

  def check_permission
    controller_permissions = permissions[controller_name.to_sym]
    roles = current_api_v1_user.roles.map &:to_sym
    if !(controller_permissions.keys & roles).empty?
      actions = []
      (controller_permissions.keys & roles).each do |action| 
        actions = actions | controller_permissions[action]
      end
      forbidden_error if !actions.include?(action_name.to_sym)
    else
      forbidden_error
    end
  end
end
