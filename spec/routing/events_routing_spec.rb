require "rails_helper"

RSpec.describe Api::V1::EventsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/events").to route_to("api/v1/events#index", format: :json)
    end

    it "routes to #show" do
      expect(get: "/api/v1/events/1").to route_to("api/v1/events#show", id: "1", format: :json)
    end
  end
end
