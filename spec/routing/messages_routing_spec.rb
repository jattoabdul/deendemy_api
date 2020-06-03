require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/conversations/1/messages').to route_to('api/v1/messages#index', conversation_id: '1', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/conversations/1/messages').to route_to('api/v1/messages#create', conversation_id: '1', format: :json)
    end

    it 'routes to #bulk_create' do
      expect(post: '/api/v1/conversations/messages').to route_to('api/v1/messages#bulk_create', format: :json)
    end
  end
end
