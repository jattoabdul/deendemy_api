require 'rails_helper'

RSpec.describe Api::V1::WishlistsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/accounts/1/wishlists').to route_to('api/v1/wishlists#index', account_id: '1', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/accounts/1/wishlists/1').to route_to('api/v1/wishlists#show', account_id: '1', id: '1', format: :json)
    end

    it 'routes to #add_to_wishlist' do
      expect(post: '/api/v1/accounts/1/wishlists/add').to route_to('api/v1/wishlists#add_to_wishlist', account_id: '1', format: :json)
    end

    it 'routes to #remove_from_wishlist' do
      expect(post: '/api/v1/accounts/1/wishlists/remove').to route_to('api/v1/wishlists#remove_from_wishlist', account_id: '1', format: :json)
    end
  end
end
