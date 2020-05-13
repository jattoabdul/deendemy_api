class Rating
  include Mongoid::Document
  include Mongoid::Timestamps
  include Eventable
  include Notifiable
  include Serializable
  extend Enumerize

  # Fields
  field :course_id, type: BSON::ObjectId
  field :user_id, type: BSON::ObjectId
  field :rating, type: Integer, default: 0
  field :review, type: String
  enumerize :status, in: %i(published flagged suspended), default: :published, predicates: true, scope: :shallow
  field :is_deleted, type: Mongoid::Boolean, default: false

  # Associations
  belongs_to :course
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  # Validations
  validates_presence_of :course_id, :user_id, :rating, :status, :is_deleted
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  # Hooks/Callbacks

  # Scopes
  scope :is_active, -> { where(status: 'published', is_deleted: false) }

  # Methods
end
