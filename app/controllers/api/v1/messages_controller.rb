class Api::V1::MessagesController < Api::V1::ApplicationController
  before_action :set_conversation, only: %i(index create)

  # GET conversations/:conversation_id/messages
  def index
    @conversation.messages.where(receiver_id: current_api_v1_user.id, read: false).update_all(read: true)
    # TODO: paginate and load first 20 messages only
    @messages = @conversation.messages

    render json: @messages
  end

  # POST conversations/:conversation_id/messages
  def create
    @message = @conversation.messages.new(message_params.except(:recipient_ids))
    @message.sender_id = current_api_v1_user.id
    @message.receiver_id = @conversation.recipient(current_api_v1_user)
    @message.save!

    render json: @message, status: :created
  end

  # POST conversations/messages
  def bulk_create
    bad_request_error('No message recipients provided') && return unless message_params[:recipient_ids].present?

    message_params[:recipient_ids].each do |recipient_id|
      conversation = Conversation.create!({ sender_id: current_api_v1_user.id, receiver_id: recipient_id })
      message = conversation.messages.new(message_params.except(:recipient_ids))
      message.sender_id = current_api_v1_user.id
      message.receiver_id = conversation.recipient(current_api_v1_user) # recipient_id
      message.save!
    end
  
    render json: { status: 'success', message: 'Bulk Messages Sent' }, status: 200
  end

  private

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:body, :priority, :recipient_ids)
    end

    def set_conversation
      @conversation = Conversation.find(params[:conversation_id])
    end
end
