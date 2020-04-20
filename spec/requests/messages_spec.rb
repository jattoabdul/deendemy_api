require 'rails_helper'

RSpec.describe "/messages", type: :request do
  xdescribe "Authorized user" do
    let(:user) { build :user }
    sign_in(:user)
    let(:valid_attributes) { attributes_for(:message) }
  
    let(:invalid_attributes) { attributes_for(:invalid_message) }
  
    let(:valid_headers) { auth_helpers_auth_token }
  
    describe "GET /index" do
      it "renders a successful response" do
        Message.create! valid_attributes
        get messages_url, headers: valid_headers, as: :json
        expect(response).to be_successful
      end
    end
  
    describe "GET /show" do
      it "renders a successful response" do
        message = Message.create! valid_attributes
        get message_url(message), as: :json
        expect(response).to be_successful
      end
    end
  
    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new Message" do
          expect {
            post messages_url,
                 params: { message: valid_attributes }, headers: valid_headers, as: :json
          }.to change(Message, :count).by(1)
        end
  
        it "renders a JSON response with the new message" do
          post messages_url,
               params: { message: valid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
  
      context "with invalid parameters" do
        it "does not create a new Message" do
          expect {
            post messages_url,
                 params: { message: invalid_attributes }, as: :json
          }.to change(Message, :count).by(0)
        end
  
        it "renders a JSON response with errors for the new message" do
          post messages_url,
               params: { message: invalid_attributes }, headers: valid_headers, as: :json
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
  
        it "updates the requested message" do
          message = Message.create! valid_attributes
          patch message_url(message),
                params: { message: invalid_attributes }, headers: valid_headers, as: :json
          message.reload
          skip("Add assertions for updated state")
        end
  
        it "renders a JSON response with the message" do
          message = Message.create! valid_attributes
          patch message_url(message),
                params: { message: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq("application/json")
        end
      end
  
      context "with invalid parameters" do
        it "renders a JSON response with errors for the message" do
          message = Message.create! valid_attributes
          patch message_url(message),
                params: { message: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to eq("application/json")
        end
      end
    end
  
    describe "DELETE /destroy" do
      it "destroys the requested message" do
        message = Message.create! valid_attributes
        expect {
          delete message_url(message), headers: valid_headers, as: :json
        }.to change(Message, :count).by(-1)
      end
    end
  end
end
