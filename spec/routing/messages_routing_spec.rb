require "rails_helper"

RSpec.describe Api::V1::MessagesController, type: :routing do
  xdescribe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/messages").to route_to("api/v1/messages#index", format: :json)
    end

    it "routes to #show" do
      expect(get: "/api/v1/messages/1").to route_to("api/v1/messages#show", id: "1", format: :json)
    end


    it "routes to #create" do
      expect(post: "/api/v1/messages").to route_to("api/v1/messages#create", format: :json)
    end

    it "routes to #update via PUT" do
      expect(put: "/api/v1/messages/1").to route_to("api/v1/messages#update", id: "1", format: :json)
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/v1/messages/1").to route_to("api/v1/messages#update", id: "1", format: :json)
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/messages/1").to route_to("api/v1/messages#destroy", id: "1", format: :json)
    end
  end
end
