class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Eventable
  include Notifiable
  include Serializable
  extend Enumerize

  # Fields
  field :body, type: String
  field :priority, type: String
  enumerize :priority, in: [:normal, :high, :critical], default: :normal, predicates: { prefix: true }
  field :read,  type: Mongoid::Boolean, default: false
  field :is_deleted, type: Mongoid::Boolean, default: false
  field :conversation_id, type: BSON::ObjectId
  field :sender_id, type: BSON::ObjectId
  field :receiver_id, type: BSON::ObjectId

  # Associations
  belongs_to :conversation
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  has_many :medias

  # Validations
  validates_presence_of :body, :conversation_id, :sender_id, :receiver_id

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'message.created', eventable: self, data: serialize)
    EmitNewMessageJob.perform_async(id.to_s, 'Deendemy::MessageActionCableDispatcher')
    create_notifications # NB: not necessary to loop in this function, change later
    # emit total_unread_message_count for self.receiver of this message
  end

  index({ conversation_id: 1 }, { name: 'index_messages_on_conversation_id', background: true })
  index({ user_id: 1 }, { name: 'index_messages_on_user_id', background: true })

  def formated_message_time
    {
      date_time_pretty_short: created_at.strftime("%d/%m/%y at %l:%M %p")
    }
  end

  private

  def message_time
    created_at.strftime("%d/%m/%y at %l:%M %p")
  end

  def recipients
    # ([comment.article.user] + comment.article.reload.commented_users.to_a - [comment.user]).uniq
    [receiver].uniq
  end

  def create_notifications
    recipients.each do |recipient|
      Notification.create(recipient: recipient, actor: sender,
        action: 'message_created', notifiable: self, data: serialize)
    end
  end
end
