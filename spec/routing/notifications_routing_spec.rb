require "rails_helper"

RSpec.describe Api::V1::NotificationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/notifications").to route_to("api/v1/notifications#index", format: :json)
    end

    it "routes to #show" do
      expect(get: "/api/v1/notifications/1").to route_to("api/v1/notifications#show", id: "1", format: :json)
    end


    it "routes to #mark_all_as_read" do
      expect(post: "/api/v1/notifications/read").to route_to("api/v1/notifications#mark_all_as_read", format: :json)
    end

    it "routes to #mark_as_read via PUT" do
      expect(put: "/api/v1/notifications/1/read").to route_to("api/v1/notifications#mark_as_read", id: "1", format: :json)
    end
  end
end
