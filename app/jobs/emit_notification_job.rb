class EmitNotificationJob
  include Sidekiq::Worker
  sidekiq_options queue: :events, retry: 3

  # @param id [String] Notification ID
  # @param dispatcher [String]
  def perform(id, dispatcher)
    # Ensure uncached query of Notification
    notification = Notification.find(id)
    dispatcher = dispatcher.constantize.new
    dispatcher.emit(notification)
  end
end
