class Course
  include Mongoid::Document
  include Mongoid::Timestamps
  include Eventable
  include Notifiable
  include Serializable
  extend Enumerize

  # Fields
  field :title, type: String
  field :subtitle, type: String
  field :tutor_id, type: BSON::ObjectId
  field :label_id, type: BSON::ObjectId
  field :introduction_id, type: BSON::ObjectId
  enumerize :type, in: [:free, :paid], default: :paid, predicates:  true
  field :price, type: Float
  enumerize :status, in: [:draft, :approval, :approved, :rejected, :published, :archived], default: :draft, predicates: true
  field :copy_text, type: Mongoid::Boolean, default: true
  field :seo, type: Hash, default: {} # {title, decription, tags}
  field :language, type: String # make enum of supported languages later
  enumerize :level, in: [:beginner, :intermediate, :expert, :everyone], default: :everyone, predicates: true
  field :configs, type: Array, default: []

  # Validations
  validates_presence_of :title, :tutor_id
  # validates :price, presence: true unless type == free

  # Associations
  has_and_belongs_to_many :categories, autosave: true
  belongs_to :tutor, class_name: 'User', foreign_key: 'tutor_id'
  belongs_to :label, class_name: 'Media', foreign_key: 'label_id'
  has_many :chapters
  has_many :lessons, through: :chapters
  belongs_to :introduction, class_name: 'Lesson', foreign_key: 'introduction_id', required: false, optional: true
  # has_many :enrollments
  # has_many :learners, class_name: 'User', through :enrollments
  # belongs_to :course # to be added on enrollment

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'course.created', eventable: self, data: serialize)
    # TODO: loop through list of admins including current user and for each user_id
    # Notification.create(recipient: user_id, actor: tutor, action: 'course_created', notifiable: self, data: serialize)
  end
end
