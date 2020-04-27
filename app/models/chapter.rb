class Chapter
  include Mongoid::Document
  include Mongoid::Timestamps
  include Eventable
  include Notifiable
  include Serializable
  include Referenceable

  # Fields
  field :course_id, type: BSON::ObjectId
  field :reference, type: String
  field :title, type: String
  field :objective, type: String
  field :is_last, type: Mongoid::Boolean, default: false

  # Associations
  belongs_to :course, required: true
  has_many :lessons

  # Validations
  validates_presence_of :title, :reference, :course_id

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'chapter.created', eventable: self, data: serialize)
  end
end
