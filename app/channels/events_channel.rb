class EventsChannel < ApplicationCable::Channel
  # Streams events that are broadcasted
  def subscribed
    stream_from 'events'
  end

  def unsubscribed
    stop_all_streams
  end
end
