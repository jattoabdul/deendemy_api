class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :is_deleted
  
  belongs_to :sender, serializer: UserSerializer
  belongs_to :receiver, serializer: UserSerializer
end
