class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :read_at, :action, :notifiable_type, :data

  belongs_to :recipient, serializer: UserSerializer
  belongs_to :actor, serializer: UserSerializer
end
