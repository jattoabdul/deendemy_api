require 'rails_helper'

RSpec.describe Api::V1::ChaptersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/courses/1/chapters').to route_to('api/v1/chapters#index', course_id: '1', format: :json)
    end

    it 'routes to #all_chapters' do
      expect(get: '/api/v1/chapters').to route_to('api/v1/chapters#all_chapters', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/courses/1/chapters/1').to route_to('api/v1/chapters#show', course_id: '1', id: '1', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/courses/1/chapters').to route_to('api/v1/chapters#create', course_id: '1', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/courses/1/chapters/1').to route_to('api/v1/chapters#update', course_id: '1', id: '1', format: :json)
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/courses/1/chapters/1').to route_to('api/v1/chapters#update', course_id: '1', id: '1', format: :json)
    end

    it 'routes to #update_positions' do
      expect(post: '/api/v1/courses/1/chapters/positions').to route_to('api/v1/chapters#update_positions', course_id: '1', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/courses/1/chapters/1').to route_to('api/v1/chapters#destroy', course_id: '1', id: '1', format: :json)
    end
  end
end
