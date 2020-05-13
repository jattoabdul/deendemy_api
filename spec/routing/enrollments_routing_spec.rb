require "rails_helper"

RSpec.describe EnrollmentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/enrollments").to route_to("enrollments#index")
    end

    it "routes to #show" do
      expect(get: "/enrollments/1").to route_to("enrollments#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/enrollments").to route_to("enrollments#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/enrollments/1").to route_to("enrollments#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/enrollments/1").to route_to("enrollments#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/enrollments/1").to route_to("enrollments#destroy", id: "1")
    end
  end
end
