class LessonDiscussion
  include Mongoid::Document
  include Mongoid::Timestamps
  include Eventable
  include Notifiable
  include Serializable

  # Fields
  field :course_id, type: BSON::ObjectId
  field :lesson_id, type: BSON::ObjectId
  field :sender_id, type: BSON::ObjectId
  field :body, type: String
  field :is_deleted, type: Mongoid::Boolean, default: false
  field :parent_id, type: BSON::ObjectId
  
  # Associations
  belongs_to :parent, class_name: 'LessonDiscussion', inverse_of: :children, required: false, optional: true
  has_many :children, class_name: 'LessonDiscussion', inverse_of: :parent
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :course
  belongs_to :lesson

  # Validations
  validates_presence_of :body, :lesson_id, :sender_id, :course_id

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'lesson_discussion.created', eventable: self, data: serialize.as_json)
    # EmitNewDiscussionMessageJob.perform_async(id.to_s, 'Deendemy::LessonDiscussionActionCableDispatcher')
    create_notifications
  end

  index({ lesson_id: 1 }, { name: 'index_lesson_discussions_on_lesson_id', background: true })
  index({ sender_id: 1 }, { name: 'index_lesson_discussions_on_sender_id', background: true })

  # Methods
  def formated_discussion_time
    {
      date_time_pretty_short: discussion_time
    }
  end

  private

  def discussion_time
    created_at.strftime("%d/%m/%y at %l:%M %p")
  end

  def recipients
    # ([lesson.chapter.course.tutor] + lesson.chapter.course.enrolled_users.to_a - [sender]).uniq
    [lesson.chapter.course.tutor].uniq
  end

  def create_notifications
    recipients.each do |recipient|
      Notification.create(recipient: recipient, actor: sender,
        action: 'lesson_discussion_created', notifiable: self, data: serialize.as_json)
    end
  end
end
