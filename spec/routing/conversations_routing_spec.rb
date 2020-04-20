require "rails_helper"

RSpec.describe Api::V1::ConversationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/conversations").to route_to("api/v1/conversations#index", format: :json)
    end

    xit "routes to #show" do
      expect(get: "/api/v1/conversations/1").to route_to("api/v1/conversations#show", id: "1", format: :json)
    end


    it "routes to #create" do
      expect(post: "/api/v1/conversations").to route_to("api/v1/conversations#create", format: :json)
    end

    xit "routes to #update via PUT" do
      expect(put: "/api/v1/conversations/1").to route_to("api/v1/conversations#update", id: "1", format: :json)
    end

    xit "routes to #update via PATCH" do
      expect(patch: "/api/v1/conversations/1").to route_to("api/v1/conversations#update", id: "1", format: :json)
    end

    xit "routes to #destroy" do
      expect(delete: "/api/v1/conversations/1").to route_to("api/v1/conversations#destroy", id: "1", format: :json)
    end
  end
end
