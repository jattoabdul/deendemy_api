require 'rails_helper'

RSpec.describe Api::V1::CoursesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/courses').to route_to('api/v1/courses#index', format: :json)
    end

    it 'routes to #fetch_all' do
      expect(get: '/api/v1/courses/all').to route_to('api/v1/courses#fetch_all', format: :json)
    end

    it 'routes to #fetch_tutor_courses' do
      expect(get: '/api/v1/courses/tutor').to route_to('api/v1/courses#fetch_tutor_courses', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/courses/1').to route_to('api/v1/courses#show', id: '1', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/courses').to route_to('api/v1/courses#create', format: :json)
    end

    it 'routes to #approve' do
      expect(post: '/api/v1/courses/1/approve').to route_to('api/v1/courses#approve', id: '1', format: :json)
    end

    it 'routes to #fetch_course_reviews' do
      expect(get: '/api/v1/courses/1/reviews').to route_to('api/v1/courses#fetch_course_reviews', id: '1', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/courses/1').to route_to('api/v1/courses#update', id: '1', format: :json)
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/courses/1').to route_to('api/v1/courses#update', id: '1', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/courses/1').to route_to('api/v1/courses#destroy', id: '1', format: :json)
    end
  end
end
