module Deendemy
  class ActionCableDispatcher
    # @param event [Event]
    # @return [True]
    def emit(event)
      event = ActiveModelSerializers::SerializableResource.new(event).as_json
      ActionCable.server.broadcast('events', event: Hash.new(event))
      true
    end
  end
end
