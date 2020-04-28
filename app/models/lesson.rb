class Lesson
  include Mongoid::Document
  include Mongoid::Timestamps
  include Eventable
  include Notifiable
  include Serializable
  include Referenceable
  extend Enumerize

  # Fields
  field :reference, type: String
  enumerize :type, in: [:lecture, :quiz, :survey], default: :lecture, predicates:  true
  field :title, type: String
  field :description, type: String
  # store assesment_id for all other lesson types except lecture
  field :assessment_id, type: BSON::ObjectId
  field :content_id, type: BSON::ObjectId
  field :additional_resource_id, type: BSON::ObjectId
  enumerize :status, in: [:draft, :published], default: :draft, predicates: true
  field :prerequisite, type: Mongoid::Boolean
  field :downloadable, type: Mongoid::Boolean
  field :can_discuss, type: Mongoid::Boolean
  field :is_last, type: Mongoid::Boolean
  field :chapter_id, type: BSON::ObjectId

  # Associations
  belongs_to :chapter, class_name: 'Chapter', foreign_key: 'chapter_id', required: false, optional: true
  # belongs_to: assessment unless type == lecture
  # belongs_to: content, class_name: 'Media'
  # belongs_to: additional_resource, class_name: 'Media'

  # Validations
  validates_presence_of :title
  validates :reference, presence: true, uniqueness: true

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'lesson.created', eventable: self, data: serialize)
  end

  # Methods
end
