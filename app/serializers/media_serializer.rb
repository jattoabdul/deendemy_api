class MediaSerializer < ActiveModel::Serializer
  attributes :id, :type, :title, :description, :is_deleted

  belongs_to :user, serializer: UserSerializer
  belongs_to :message

  # TODO: Add more attributes from aws to serializer
  attribute :item do
    object.item.url
  end
end
