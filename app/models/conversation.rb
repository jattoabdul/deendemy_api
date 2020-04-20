class Conversation
  include Mongoid::Document
  include Eventable
  include Serializable

  # Fields
  field :is_deleted, type: Mongoid::Boolean, default: false
  field :sender_id, type: BSON::ObjectId
  field :receiver_id, type: BSON::ObjectId

  # Associations
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
  has_many :messages, dependent: :destroy

  # Validations
  validates_uniqueness_of :sender_id, scope: :receiver_id

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'conversation.created', eventable: self, data: serialize)
  end

  # Scopes
  scope :between, -> (sender_id, receiver_id) do
    any_of({sender_id: sender_id, receiver_id: receiver_id}, {sender_id: receiver_id, receiver_id: sender_id})
  end

  def recipient(current_user)
    self.sender_id == current_user.id ? self.receiver : self.sender
  end
end
