require 'rails_helper'

RSpec.describe "/categories", type: :request do
  describe 'Authorized user' do
    let(:user) { build :user }
    sign_in(:user)
    let(:valid_attributes) { attributes_for(:category) }
  
    let(:invalid_attributes) { attributes_for(:invalid_category) }
  
    let(:valid_headers) { auth_helpers_auth_token }
  
    describe "GET /index" do
      it "renders a successful response" do
        Category.create! valid_attributes
        get api_v1_categories_url, headers: valid_headers, as: :json
        expect(response).to be_successful
      end
    end
  
    describe "GET /show" do
      it "renders a successful response" do
        category = Category.create! valid_attributes
        get api_v1_category_url(category), as: :json
        expect(response).to be_successful
      end
    end
  
    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new Category" do
          expect {
            post api_v1_categories_url,
                 params: { category: valid_attributes }, headers: valid_headers, as: :json
          }.to change(Category, :count).by(1)
        end
  
        it "renders a JSON response with the new category" do
          post api_v1_categories_url,
               params: { category: valid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
  
      context "with invalid parameters" do
        it "does not create a new Category" do
          expect {
            post api_v1_categories_url,
                 params: { category: invalid_attributes }, as: :json
          }.to change(Category, :count).by(0)
        end
  
        it "renders a JSON response with errors for the new category" do
          post api_v1_categories_url,
               params: { category: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  
    describe "PATCH /update" do
      context "with valid parameters" do
        let(:new_attributes) {
          attributes_for(:category, name: "Random")
        }
  
        it "updates the requested category" do
          category = Category.create! valid_attributes
          patch api_v1_category_url(category),
                params: { category: new_attributes }, headers: valid_headers, as: :json
          category.reload
          expect(json(response)[:category][:name]).to eq("Random")
        end
  
        it "renders a JSON response with the category" do
          category = Category.create! valid_attributes
          patch api_v1_category_url(category),
                params: { category: new_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
  
      context "with invalid parameters" do
        it "renders a JSON response with errors for the category" do
          category = Category.create! valid_attributes
          patch api_v1_category_url(category),
                params: { category: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  
    describe "DELETE /destroy" do
      it "destroys the requested category" do
        category = Category.create! valid_attributes
        expect {
          delete api_v1_category_url(category), headers: valid_headers, as: :json
        }.to change(Category, :count).by(-1)
      end
    end
  end
end
