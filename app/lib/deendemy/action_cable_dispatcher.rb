module Deendemy
  class ActionCableDispatcher
    # @param event [Event]
    # @return [True]
    def emit(event)
      ActionCable.server.broadcast('events', event.serialize)
      true
    end
  end
end
