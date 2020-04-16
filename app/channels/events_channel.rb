class EventsChannel < ApplicationCable::Channel
  # Streams events that are broadcasted
  def subscribed
    stream_from 'events'
  end
end
