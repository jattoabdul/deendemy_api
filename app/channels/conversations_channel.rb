class ConversationsChannel < ApplicationCable::Channel
  # Streams events that are broadcasted
  def subscribed
    if params[:channel_id].present?
      stream_from("Conversation-#{params[:channel_id]}")
    end
  end

  # calls when a client broadcasts data
  def speak(data)
    sender = get_sender(data['sender'])
    conversation_id = data['conversation_id']
    message = data['message']

    raise 'No conversation_id!' if conversation_id.blank?
    convo = get_convo(conversation_id) # A conversation
    raise 'No conversation found!' if convo.blank?
    raise 'No message!' if message.blank?

    # set receiver of message
    # receiver = get_user(data['receiver']) || convo.recipient(sender)

    # saves the message and its data to the DB
    Message.create!(
      conversation: convo,
      sender: sender,
      # receiver: receiver,
      receiver: convo.recipient(sender),
      body: message
    )
  end
  
  # Helpers
  def get_convo(conversation_id)
    Conversation.find_by(id: conversation_id)
  end
  
  def get_sender(userId)
    User.find_by(id: userId)
  end
end
