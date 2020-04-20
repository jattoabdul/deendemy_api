class Api::V1::ConversationsController < Api::V1::ApplicationController

  # GET /conversations
  def index
    @conversations = Conversation.any_of({sender_id: current_api_v1_user.id}, {receiver_id: current_api_v1_user.id})
    # TODO: emit conversation_(has_unread) flag for each conversation for current user

    render json: @conversations
  end

  def create
    sender = conversation_params[:sender_id]
    receiver = conversation_params[:receiver_id]
    @conversation = if existing_conversation(sender, receiver).present?
      existing_conversation(sender, receiver).first 
    else
      Conversation.create!(conversation_params)
    end

    render json: @conversation, status: :created
  end

  private

    # Only allow a trusted parameter "white list" through.
    def conversation_params
      params.require(:conversation).permit(:sender_id, :receiver_id)
    end

    def existing_conversation(sender, receiver)
      Conversation.between(sender, receiver)
    end
end
