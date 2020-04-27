class Course
  include Mongoid::Document
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
  field :curriculum, type: Array
  enumerize :type, in: [:free, :paid], default: :paid, predicates:  true
  field :price, type: Float
  enumerize :status, in: [:draft, :approval, :approved, :rejected, :published, :archived], default: :draft, predicates: true
  field :copy_text, type: Mongoid::Boolean, default: true
  field :seo, type: Hash, default: {} # {title, decription, tags}
  field :language, type: String # make enum of supported languages later
  enumerize :level, in: [:beginner, :intermediate, :expert, :everyone], default: :everyone, predicates: true
  field :configs, type: Array, default: []

  # Validations
  # validates_presence_of :body, :conversation_id, :sender_id, :receiver_id
  # validates :reference, presence: true, uniqueness: true

  # Associations
  has_and_belongs_to_many :categories, autosave: true
  belongs_to :tutor, class_name: 'User', foreign_key: 'tutor_id'
  belongs_to :label, class_name: 'Media', foreign_key: 'label_id' 
  # belongs_to :introduction, class_name: 'Lesson', foreign_key: 'introduction_id' 
  # has_and_belongs_to_many :learners, class_name: 'User', foreign_key: 'learner_ids' # maybe through enrollments
  # has_one :introduction, class_name: 'Lesson', foreign_key: 'introduction_id' 

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'course.created', eventable: self, data: serialize)
    Notification.create(recipient: tutor, actor: tutor, action: 'course_created', notifiable: self, data: serialize)
  end
end
