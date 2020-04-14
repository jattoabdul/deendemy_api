require "rails_helper"

RSpec.describe "Token Validations", type: :request do
  describe 'signed in' do
    let(:user) { build :user }
    sign_in(:user)
    # NOTE: use auth_helpers_auth_token as header param
    # The authentication header looks something like this:
    # {"access-token"=>"abcd1dMVlvW2BT67xIAS_A", "token-type"=>"Bearer", "client"=>"LSJEVZ7Pq6DX5LXvOWMq1w", "expiry"=>"1519086891", "uid"=>"darnell@konopelski.info"}

    it 'should respond with success' do
      get '/auth/validate_token'
      expect(response).to have_http_status(:success)
    end
    it 'returns access-token in authentication header' do
      expect(auth_helpers_auth_token['access-token']).to be_present
    end
    it 'returns client in authentication header' do
      expect(auth_helpers_auth_token['client']).to be_present
    end
    it 'returns expiry in authentication header' do
        expect(auth_helpers_auth_token['expiry']).to be_present
      end
    it 'returns uid in authentication header' do
      expect(auth_helpers_auth_token['uid']).to be_present
    end
  end

  describe 'signed out' do
    it 'should respond with unauthorized' do
      get '/auth/validate_token'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
