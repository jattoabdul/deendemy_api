require "rails_helper"

RSpec.describe MediasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/medias").to route_to("medias#index")
    end

    it "routes to #show" do
      expect(get: "/medias/1").to route_to("medias#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/medias").to route_to("medias#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/medias/1").to route_to("medias#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/medias/1").to route_to("medias#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/medias/1").to route_to("medias#destroy", id: "1")
    end
  end
end
