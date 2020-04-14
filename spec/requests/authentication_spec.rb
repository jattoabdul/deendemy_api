require 'rails_helper'
include ActionController::RespondWith

RSpec.describe "Authentication", type: :request do
  # TODO: Fix this signin/signout test to pass
  xdescribe 'Whether access is ocurring properly', type: :request do
    let(:current_user){create(:user, email: 'user@example.com', password: 'password')}
    sign_in(:current_user)
  
    context 'context: general authentication via API, ' do
      it 'gives you an authentication code if you are an existing user and you satisfy the password' do
        
        login
        puts "#{response.headers.inspect}"
        puts "#{response.body.inspect}"
        expect(response.has_header?('access-token')).to eq(true)
      end
  
      it 'gives you a status 200 on signing in ' do
        login
        expect(response.status).to eq(200)
      end
    end
  
    def login
      post api_user_session_url, params:  { email: current_user.email, password: 'password' }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    end
  
    def get_auth_params_from_login_response_headers(response)
      client = response.headers['client']
      token = response.headers['access-token']
      expiry = response.headers['expiry']
      token_type = response.headers['token-type']
      uid = response.headers['uid']
  
      auth_params = {
        'access-token' => token,
        'client' => client,
        'uid' => uid,
        'expiry' => expiry,
        'token-type' => token_type
      }
      auth_params
    end
  end
end
