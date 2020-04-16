require 'rails_helper'

RSpec.describe "/events", type: :request do
  describe "Authorized user" do
    let(:user) { build :user, :admin_only }
    sign_in(:user)
    let(:valid_attributes) { attributes_for(:event) }
  
    let(:invalid_attributes) { attributes_for(:invalid_event) }
  
    let(:valid_headers) { auth_helpers_auth_token }

    describe "GET /index" do
      it "renders a successful response" do
        Event.create! valid_attributes
        get api_v1_events_url, headers: valid_headers, as: :json
        expect(response).to be_successful
      end
    end
  
    describe "GET /show" do
      it "renders a successful response" do
        event = Event.create! valid_attributes
        get api_v1_event_url(event), as: :json
        expect(response).to be_successful
      end
    end
  end
end
