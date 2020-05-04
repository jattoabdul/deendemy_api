require "rails_helper"

RSpec.describe LessonDiscussionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/lesson_discussions").to route_to("lesson_discussions#index")
    end

    it "routes to #show" do
      expect(get: "/lesson_discussions/1").to route_to("lesson_discussions#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/lesson_discussions").to route_to("lesson_discussions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/lesson_discussions/1").to route_to("lesson_discussions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/lesson_discussions/1").to route_to("lesson_discussions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/lesson_discussions/1").to route_to("lesson_discussions#destroy", id: "1")
    end
  end
end
