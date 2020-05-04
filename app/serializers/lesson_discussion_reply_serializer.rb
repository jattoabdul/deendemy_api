class LessonDiscussionReplySerializer < ActiveModel::Serializer
  attributes :id, :body

  belongs_to :sender, serializer: UserSerializer

  attribute :root do
    object.parent_id.blank?
  end

  def created_at
    object.formated_message_time
  end
end
