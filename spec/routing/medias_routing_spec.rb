require 'rails_helper'

RSpec.describe Api::V1::MediasController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/medias').to route_to('api/v1/medias#index', format: :json)
    end

    it 'routes to #my_media' do
      expect(get: '/api/v1/accounts/1/medias').to route_to('api/v1/medias#my_media', account_id: '1', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/medias/1').to route_to('api/v1/medias#show', id: '1', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/medias').to route_to('api/v1/medias#create', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/medias/1').to route_to('api/v1/medias#update', id: '1', format: :json)
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/medias/1').to route_to('api/v1/medias#update', id: '1', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/medias/1').to route_to('api/v1/medias#destroy', id: '1', format: :json)
    end
  end
end
