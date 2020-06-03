require 'rails_helper'

RSpec.describe Api::V1::CartsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/accounts/1/carts').to route_to('api/v1/carts#index', account_id: '1', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/accounts/1/carts/1').to route_to('api/v1/carts#show', id: '1', account_id: '1', format: :json)
    end

    it 'routes to #add_to_cart via POST' do
      expect(post: '/api/v1/accounts/1/carts/add').to route_to('api/v1/carts#add_to_cart', account_id: '1', format: :json)
    end

    it 'routes to #remove_from_cart via POST' do
      expect(post: '/api/v1/accounts/1/carts/remove').to route_to('api/v1/carts#remove_from_cart', account_id: '1', format: :json)
    end
  end
end
