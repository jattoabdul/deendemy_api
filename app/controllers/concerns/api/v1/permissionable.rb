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
      },
      conversations: {
        admin: [ :index, :create, :show, :destroy ],
        support: [ :index, :create, :show ],
        tutor: [ :index, :create ],
        learner: [:index, :create ]
      },
      messages: {
        admin: [ :index, :create, :show, :bulk_create ],
        support: [ :index, :create, :show, :bulk_create ],
        tutor: [ :index, :create, :bulk_create ],
        learner: [:index, :create ]
      },
      accounts: {
        admin: [ :index, :assign_roles, :unassign_roles ],
        support: [ :index ],
        tutor: [],
        learner: []
      },
      medias: {
        admin: [ :index, :my_media, :show, :create, :update, :destroy ],
        support: [ :index, :my_media, :show, :create, :update, :destroy ],
        tutor: [ :my_media, :show, :create, :update, :destroy ],
        learner: [ :my_media, :show, :create, :update, :destroy ]
      },
      courses: {
        admin: [ :index, :show, :create, :update, :destroy ],
        support: [ :index, :show, :update, :destroy  ],
        tutor: [ :index, :show, :create, :update, :destroy ],
        learner: [ :index, :show ]
      }
    }
  end

  def check_permission
    controller_permissions = permissions[controller_name.to_sym]
    return true if controller_permissions.blank? # avoid checking permission if permission not set for controller
    roles = current_api_v1_user.roles.map &:to_sym if current_api_v1_user.present?
    roles ||= []
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
