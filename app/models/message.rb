class Message
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Eventable
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

  # Validations
  validates_presence_of :body, :conversation_id, :sender_id, :receiver_id

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'message.created', eventable: self, data: serialize)
    EmitNewMessageJob.perform_async(id.to_s, 'Deendemy::MessageActionCableDispatcher')
    # emit notification(message) for self.receiver of this message from self.sender
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
end
