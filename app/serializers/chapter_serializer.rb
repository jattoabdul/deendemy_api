class ChapterSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :description, :public_url, :message_id, :is_deleted
end
