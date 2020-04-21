class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body, :priority, :read, :is_deleted, :created_at

  belongs_to :sender, serializer: UserSerializer
  belongs_to :receiver, serializer: UserSerializer
  belongs_to :conversation

  def created_at
    object.formated_message_time
  end
end
