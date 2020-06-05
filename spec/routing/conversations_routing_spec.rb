require 'rails_helper'

RSpec.describe Api::V1::ConversationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/conversations').to route_to('api/v1/conversations#index', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/conversations').to route_to('api/v1/conversations#create', format: :json)
    end
  end
end
