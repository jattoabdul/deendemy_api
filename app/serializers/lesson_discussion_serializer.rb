class LessonDiscussionSerializer < ActiveModel::Serializer
  attributes :id, :body

  belongs_to :course
  belongs_to :lesson
  belongs_to :sender, serializer: UserSerializer
  belongs_to :parent, key: :root_discussion, serializer: LessonDiscussionSerializer, if: :is_parent?
  belongs_to :parent, key: :root_discussion, serializer: LessonDiscussionReplySerializer, if: -> { object.parent_id.present? }
  # has_many :children, key: :discussion_replies, each_serializer: LessonDiscussionReplySerializer

  attribute :root do
    object.parent_id.blank?
  end

  attribute :discussion_replies do
    ActiveModelSerializers::SerializableResource.new(object.children,  each_serializer: LessonDiscussionReplySerializer, adapter: :attributes)
  end

  def is_parent?
    object.parent_id.blank?
  end

  def created_at
    object.formated_message_time
  end
end
