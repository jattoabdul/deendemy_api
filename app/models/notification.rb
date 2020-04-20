class Notification
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :recipient_id, type: BSON::ObjectId
  field :actor_id, type: BSON::ObjectId
  field :read_at, type: Time
  field :is_deleted, type: Mongoid::Boolean, default: false
  field :action, type: String
  field :data, type: Object

  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :actor, class_name: 'User', foreign_key: 'actor_id', required: false, optional: true
  belongs_to :notifiable, polymorphic: true, required: false, optional: true

  validates_presence_of :action

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where(:read_at.nin => [nil]) }
  scope :for_user, -> (current_user) { where(recipient_id: current_user.id) }

  CABLE_NOTIFICATION_EVENTS = [
    'message_created'
  ].freeze

  after_create do
    EmitNotificationJob.perform_async(id.to_s, 'Deendemy::NotificationActionCableDispatcher') if CABLE_NOTIFICATION_EVENTS.include?(action)
  end
end
