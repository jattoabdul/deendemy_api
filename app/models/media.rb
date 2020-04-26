class Media
  include Mongoid::Document
  include Eventable
  include Notifiable
  include Serializable
  include Referenceable
  extend Enumerize

  # Fields
  enumerize :type, in: [:image, :pdf, :video, :ppt, :audio, :text], predicates:  true
  field :title, type: String
  field :reference, type: String
  field :description, type: String
  field :public_url, type: String
  field :is_deleted, type: Mongoid::Boolean
  # field :user_id, type: BSON::ObjectId
  # field :message_id, type: BSON::ObjectId

  # Associations
  belongs_to :user, required: false, optional: true
  belongs_to :message, required: false, optional: true

  # Validations
  validates_presence_of :title
  validates :public_url, presence: true, uniqueness: true

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'media.created', eventable: self, data: serialize)
  end

  # Methods
end
