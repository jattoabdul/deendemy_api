module Deendemy
  class NotificationActionCableDispatcher
    # @param event [Notification]
    # @return [True]
    def emit(notification)
      ActionCable.server.broadcast(build_notification_id(notification.recipient.id), notification: notification.as_json)
      true
    end

    # Build notification channel with recipient's id for uniqueness
    def build_notification_id(id)
      "Notification-#{id}"
    end
  end
end
