class Api::V1::MessagesController < Api::V1::ApplicationController
  before_action :set_conversation, only: [:index, :create]

  # GET conversation/:conversation_id/messages
  def index
    @conversation.messages.where(receiver_id: current_api_v1_user.id, read: false).update_all(read: true)
    # TODO: paginate and load first 20 messages only
    @messages = @conversation.messages

    render json: @messages
  end

  # POST conversation/:conversation_id/messages
  def create
    @message = @conversation.messages.new(message_params)
    @message.sender_id = current_api_v1_user.id
    @message.receiver_id = @conversation.recipient(current_api_v1_user)
    @message.save!

    render json: @message, status: :created
  end

  private

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:body, :priority)
    end

    def set_conversation
      @conversation = Conversation.find(params[:conversation_id])
    end
end
