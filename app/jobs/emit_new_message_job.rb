class EmitNewMessageJob
  include Sidekiq::Worker
  sidekiq_options queue: :messages, retry: 2

  # @param id [String] Message ID
  # @param dispatcher [String]
  def perform(id, dispatcher)
    # Ensure uncached query of message
    message = Message.find(id)
    dispatcher = dispatcher.constantize.new
    dispatcher.emit(message)
  end
end
