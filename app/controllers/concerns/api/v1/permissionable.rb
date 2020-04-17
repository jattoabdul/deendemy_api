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
      },
      events: {
        admin: [ :index, :show, :my_events ],
        support: [ :index, :show, :my_events ],
        tutor: [ :my_events ],
        learner: [:my_events ]
      }
    }
  end

  def check_permission
    controller_permissions = permissions[controller_name.to_sym]
    # TODO: rescue error if user or roles not found
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
