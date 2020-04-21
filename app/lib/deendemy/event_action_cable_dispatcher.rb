module Deendemy
  class EventActionCableDispatcher
    # @param event [Event]
    # @return [True]
    def emit(event)
      ActionCable.server.broadcast('events', event: event.as_json)
      true
    end
  end
end
