require "rails_helper"

RSpec.describe LessonsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/lessons").to route_to("lessons#index")
    end

    it "routes to #show" do
      expect(get: "/lessons/1").to route_to("lessons#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/lessons").to route_to("lessons#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/lessons/1").to route_to("lessons#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/lessons/1").to route_to("lessons#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/lessons/1").to route_to("lessons#destroy", id: "1")
    end
  end
end
