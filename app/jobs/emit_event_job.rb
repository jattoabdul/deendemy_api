class EmitEventJob
  include Sidekiq::Worker
  sidekiq_options queue: :events, retry: 3

  # @param id [String] Event ID
  # @param dispatcher [String]
  def perform(id, dispatcher)
    # Ensure uncached query of Event
    event = Event.find(id)
    dispatcher = dispatcher.constantize.new
    dispatcher.emit(event)
  end
end
