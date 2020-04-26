class MediaSerializer < ActiveModel::Serializer
  attributes :id, :userId, :type, :title, :description, :public_url, :message_id, :is_deleted
end
