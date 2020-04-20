module Deendemy
  class MessageActionCableDispatcher
    # @param event [Message]
    # @return [True]
    def emit(message)
      # Emit new message action cable event for message.receiver for this message.conversation.id
      payload = {
        conversation_id: message.conversation.id,
        body: message.body,
        sender: message.sender,
        receiver: message.receiver
      }
      ActionCable.server.broadcast(build_conversation_id(message.conversation.id), payload.as_json)
      true
    end

    def build_conversation_id(id)
      "Conversation-#{id}"
    end
  end
end
