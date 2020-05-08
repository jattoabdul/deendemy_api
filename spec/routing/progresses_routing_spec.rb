require "rails_helper"

RSpec.describe ProgressesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/progresses").to route_to("progresses#index")
    end

    it "routes to #show" do
      expect(get: "/progresses/1").to route_to("progresses#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/progresses").to route_to("progresses#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/progresses/1").to route_to("progresses#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/progresses/1").to route_to("progresses#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/progresses/1").to route_to("progresses#destroy", id: "1")
    end
  end
end
