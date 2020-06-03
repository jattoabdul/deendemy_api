require 'rails_helper'

RSpec.describe Api::V1::EnrollmentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/enrollments').to route_to('api/v1/enrollments#index', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/enrollments').to route_to('api/v1/enrollments#create', format: :json)
    end

    it 'routes to #fetch_learner_enrollments' do
      expect(get: '/api/v1/enrollments/learners/1').to route_to('api/v1/enrollments#fetch_learner_enrollments', learner_id: '1', format: :json)
    end

    it 'routes to #fetch_course_enrollments' do
      expect(get: '/api/v1/enrollments/courses/1').to route_to('api/v1/enrollments#fetch_course_enrollments', course_id: '1', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/enrollments/1').to route_to('api/v1/enrollments#show', id: '1', format: :json)
    end

    it 'routes to #toggle_enrollment_status via PUT' do
      expect(put: '/api/v1/enrollments/1/status').to route_to('api/v1/enrollments#toggle_enrollment_status', id: '1', format: :json)
    end

    it 'routes to #toggle_enrollment_status via PATCH' do
      expect(patch: '/api/v1/enrollments/1/status').to route_to('api/v1/enrollments#toggle_enrollment_status', id: '1', format: :json)
    end

    it 'routes to #start_enrollment_lesson' do
      expect(post: '/api/v1/enrollments/1/courses/1/lessons/1/start').to route_to('api/v1/enrollments#start_enrollment_lesson', id: '1', course_id: '1', lesson_id: '1', format: :json)
    end

    it 'routes to #complete_enrollment_lesson' do
      expect(post: '/api/v1/enrollments/1/courses/1/lessons/1/complete').to route_to('api/v1/enrollments#complete_enrollment_lesson', id: '1', course_id: '1', lesson_id: '1', format: :json)
    end

    it 'routes to #reset_enrollment_progress' do
      expect(post: '/api/v1/enrollments/1/progress/reset').to route_to('api/v1/enrollments#reset_enrollment_progress', id: '1', format: :json)
    end

    it 'routes to #fetch_enrollment_lesson_progresses' do
      expect(get: '/api/v1/enrollments/1/progress').to route_to('api/v1/enrollments#fetch_enrollment_lesson_progresses', id: '1', format: :json)
    end

    it 'routes to #rate_course' do
      expect(post: '/api/v1/enrollments/1/courses/1/rate').to route_to('api/v1/enrollments#rate_course', id: '1', course_id: '1', format: :json)
    end
  end
end
