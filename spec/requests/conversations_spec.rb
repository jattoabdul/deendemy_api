require 'rails_helper'

RSpec.describe "/conversations", type: :request do
  xdescribe "Authorized user" do
    let(:user) { build :user }
    sign_in(:user)
    let(:valid_attributes) { attributes_for(:conversation) }
  
    let(:invalid_attributes) { attributes_for(:invalid_conversation) }
  
    let(:valid_headers) { auth_helpers_auth_token }
  
    describe "GET /index" do
      it "renders a successful response" do
        Conversation.create! valid_attributes
        get conversations_url, headers: valid_headers, as: :json
        expect(response).to be_successful
      end
    end
  
    describe "GET /show" do
      it "renders a successful response" do
        conversation = Conversation.create! valid_attributes
        get conversation_url(conversation), as: :json
        expect(response).to be_successful
      end
    end
  
    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new Conversation" do
          expect {
            post conversations_url,
                 params: { conversation: valid_attributes }, headers: valid_headers, as: :json
          }.to change(Conversation, :count).by(1)
        end
  
        it "renders a JSON response with the new conversation" do
          post conversations_url,
               params: { conversation: valid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
  
      context "with invalid parameters" do
        it "does not create a new Conversation" do
          expect {
            post conversations_url,
                 params: { conversation: invalid_attributes }, as: :json
          }.to change(Conversation, :count).by(0)
        end
  
        it "renders a JSON response with errors for the new conversation" do
          post conversations_url,
               params: { conversation: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq("application/json")
        end
      end
    end
  
    describe "PATCH /update" do
      context "with valid parameters" do
        let(:new_attributes) {
          skip("Add a hash of attributes valid for your model")
        }
  
        it "updates the requested conversation" do
          conversation = Conversation.create! valid_attributes
          patch conversation_url(conversation),
                params: { conversation: invalid_attributes }, headers: valid_headers, as: :json
          conversation.reload
          skip("Add assertions for updated state")
        end
  
        it "renders a JSON response with the conversation" do
          conversation = Conversation.create! valid_attributes
          patch conversation_url(conversation),
                params: { conversation: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq("application/json")
        end
      end
  
      context "with invalid parameters" do
        it "renders a JSON response with errors for the conversation" do
          conversation = Conversation.create! valid_attributes
          patch conversation_url(conversation),
                params: { conversation: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq("application/json")
        end
      end
    end
  
    describe "DELETE /destroy" do
      it "destroys the requested conversation" do
        conversation = Conversation.create! valid_attributes
        expect {
          delete conversation_url(conversation), headers: valid_headers, as: :json
        }.to change(Conversation, :count).by(-1)
      end
    end
  end
end
