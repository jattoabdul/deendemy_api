require 'rails_helper'

RSpec.describe Api::V1::LessonDiscussionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/courses/1/lessons/1/discussions').to route_to('api/v1/lesson_discussions#index', course_id: '1', lesson_id: '1', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/courses/1/lessons/1/discussions/1').to route_to('api/v1/lesson_discussions#show', course_id: '1', lesson_id: '1', id: '1', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/courses/1/lessons/1/discussions').to route_to('api/v1/lesson_discussions#create', course_id: '1', lesson_id: '1', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/courses/1/lessons/1/discussions/1').to route_to('api/v1/lesson_discussions#update', course_id: '1', lesson_id: '1', id: '1', format: :json)
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/courses/1/lessons/1/discussions/1').to route_to('api/v1/lesson_discussions#update', course_id: '1', lesson_id: '1', id: '1', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/courses/1/lessons/1/discussions/1').to route_to('api/v1/lesson_discussions#destroy', course_id: '1', lesson_id: '1', id: '1', format: :json)
    end
  end
end
