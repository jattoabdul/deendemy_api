class Enrollment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Eventable
  include Notifiable
  include Serializable
  extend Enumerize
  include Referenceable

  # Fields
  field :reference, type: String
  field :payment_id, type: BSON::ObjectId
  field :course_id, type: BSON::ObjectId
  field :learner_id, type: BSON::ObjectId
  field :cancel_reason, type: String
  enumerize :status, in: %i(started completed), predicates: true, scope: :shallow
  field :progress, type: Integer
  field :is_deleted, type: Mongoid::Boolean, default: false
  
  # Associations
  belongs_to :payment, class_name: 'Payment', foreign_key: 'payment_id', autosave: true
  belongs_to :learner, class_name: 'User', foreign_key: 'learner_id'
  belongs_to :course
  has_many :progresses

  # Validations

  # Hooks/Callbacks

  # Methods
  def progress
    total_course_lessons = course.chapters.map(&:lessons).flatten(1).size
    completed_course_lessons = progresses.completed.size
    ((completed_course_lessons.to_f/total_course_lessons) * 100).to_i
  end
end
