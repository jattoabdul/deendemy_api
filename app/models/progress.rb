class Progress
  include Mongoid::Document
  include Mongoid::Timestamps
  include Eventable
  include Notifiable
  include Serializable
  extend Enumerize

  # Fields
  field :course_id, type: BSON::ObjectId
  field :lesson_id, type: BSON::ObjectId
  field :enrollment_id, type: BSON::ObjectId
  enumerize :status, in: %i(started completed), predicates: true, scope: :shallow

  # Associations
  belongs_to :course
  belongs_to :lesson
  belongs_to :enrollment, class_name: 'Enrollment', foreign_key: 'enrollment_id', autosave: true

  # Validations
  validates_presence_of :course_id, :lesson_id, :enrollment_id, :status

  # Hooks/Callbacks
  after_save do
    enrollment.update(status: 'completed') if enrollment.progress == 100
  end

  # Methods

end
