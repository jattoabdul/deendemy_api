require 'rails_helper'

RSpec.describe Api::V1::LessonsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/courses/1/chapters/1/lessons').to route_to('api/v1/lessons#index', course_id: '1', chapter_id: '1', format: :json)
    end

    it 'routes to #all_lessons' do
      expect(get: '/api/v1/lessons').to route_to('api/v1/lessons#all_lessons', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/courses/1/chapters/1/lessons/1').to route_to('api/v1/lessons#show', course_id: '1', chapter_id: '1', id: '1', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/courses/1/chapters/1/lessons').to route_to('api/v1/lessons#create', course_id: '1', chapter_id: '1', format: :json)
    end

    it 'routes to #create_lesson_assessment' do
      expect(post: '/api/v1/courses/1/chapters/1/lessons/assessments').to route_to('api/v1/lessons#create_lesson_assessment', course_id: '1', chapter_id: '1', format: :json)
    end

    it 'routes to #update_lesson_assessment via PUT' do
      expect(put: '/api/v1/courses/1/chapters/1/lessons/assessments/1').to route_to('api/v1/lessons#update_lesson_assessment', course_id: '1', chapter_id: '1', assessment_id: '1', format: :json)
    end

    it 'routes to #introduction' do
      expect(post: '/api/v1/courses/1/lessons/introduction').to route_to('api/v1/lessons#introduction', course_id: '1', format: :json)
    end

    it 'routes to #update_introduction via PUT' do
      expect(put: '/api/v1/courses/1/lessons/introduction').to route_to('api/v1/lessons#update_introduction', course_id: '1', format: :json)
    end

    it 'routes to #introduction_index' do
      expect(get: '/api/v1/courses/1/lessons/introduction').to route_to('api/v1/lessons#introduction_index', course_id: '1', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/courses/1/chapters/1/lessons/1').to route_to('api/v1/lessons#update', course_id: '1', chapter_id: '1', id: '1', format: :json)
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/courses/1/chapters/1/lessons/1').to route_to('api/v1/lessons#update', course_id: '1', chapter_id: '1', id: '1', format: :json)
    end

    it 'routes to #update_positions' do
      expect(post: '/api/v1/courses/1/chapters/1/lessons/positions').to route_to('api/v1/lessons#update_positions', course_id: '1', chapter_id: '1', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/courses/1/chapters/1/lessons/1').to route_to('api/v1/lessons#destroy', course_id: '1', chapter_id: '1', id: '1', format: :json)
    end
  end
end
