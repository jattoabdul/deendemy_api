module Api::V1::Permissionable
  extend ActiveSupport::Concern

  included do
    before_action :check_permission
  end

  def permissions
    {
      categories: {
        admin: %i(index create show update destroy),
        support: %i(index create show update),
        tutor: %i(index show),
        learner: %i(index show)
      },
      events: {
        admin: %i(index show my_events),
        support: %i(index show my_events),
        tutor: [ :my_events ],
        learner: [:my_events ]
      },
      conversations: {
        admin: %i(index create show destroy),
        support: %i(index create show),
        tutor: %i(index create),
        learner: %i(index create)
      },
      messages: {
        admin: %i(index create show bulk_create),
        support: %i(index create show bulk_create),
        tutor: %i(index create bulk_create),
        learner: %i(index create)
      },
      accounts: {
        admin: %i(index assign_roles unassign_roles),
        support: [ :index ],
        tutor: [],
        learner: []
      },
      medias: {
        admin: %i(index my_media show create update destroy),
        support: %i(index my_media show create update destroy),
        tutor: %i(my_media show create update destroy),
        learner: %i(my_media show create update destroy)
      },
      courses: {
        admin: %i(index show approve update destroy fetch_all fetch_course_reviews),
        support: %i(index show update destroy fetch_course_reviews),
        tutor: %i(index show create update destroy fetch_tutor_courses fetch_course_reviews),
        learner: %i(index show fetch_course_reviews)
      },
      chapters: {
        admin: %i(index show update update_positions destroy),
        support: %i(index show),
        tutor: %i(index show create update update_positions destroy),
        learner: %i(index show)
      },
      lessons: {
        admin: %i(index show update update_positions introduction introduction_index update_introduction create_lesson_assessment update_lesson_assessment destroy),
        support: %i(index show introduction_index),
        tutor: %i(index show create update update_positions introduction introduction_index update_introduction create_lesson_assessment update_lesson_assessment destroy),
        learner: %i(index show introduction_index)
      },
      lesson_discussions: {
        admin: %i(index show update create destroy),
        support: %i(index show update create destroy),
        tutor: %i(index show update create destroy),
        learner: %i(index show update create destroy)
      },
      carts: {
        admin: %i(index show add_to_cart remove_from_cart),
        support: %i(show add_to_cart remove_from_cart),
        tutor: %i(show add_to_cart remove_from_cart),
        learner: %i(show add_to_cart remove_from_cart)
      },
      wishlists: {
        admin: %i(index show add_to_wishlist remove_from_wishlist),
        support: %i(show add_to_wishlist remove_from_wishlist),
        tutor: %i(show add_to_wishlist remove_from_wishlist),
        learner: %i(show add_to_cart remove_from_wishlist)
      },
      payments: {
          admin: %i(index fetch_learner_payments fetch_single_payment charge),
          support: %i(fetch_learner_payments fetch_single_payment charge),
          tutor: %i(fetch_learner_payments fetch_single_payment charge),
          learner: %i(fetch_learner_payments fetch_single_payment charge)
      },
      enrollments: {
          admin: %i(index create show toggle_enrollment_status fetch_learner_enrollments fetch_course_enrollments start_enrollment_lesson complete_enrollment_lesson reset_enrollment_progress fetch_enrollment_lesson_progresses),
          support: %i(show fetch_course_enrollments),
          tutor: %i(show fetch_course_enrollments),
          learner: %i(show toggle_enrollment_status fetch_learner_enrollments start_enrollment_lesson complete_enrollment_lesson reset_enrollment_progress fetch_enrollment_lesson_progresses rate_course)
      },
      progresses: {
          # admin: %i(index show add_to_wishlist remove_from_wishlist),
          # support: %i(show add_to_wishlist remove_from_wishlist),
          # tutor: %i(show add_to_wishlist remove_from_wishlist),
          # learner: %i(show add_to_cart remove_from_wishlist)
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
        actions |= controller_permissions[action]
      end
      forbidden_error unless actions.include?(action_name.to_sym)
    else
      forbidden_error
    end
  end
end
