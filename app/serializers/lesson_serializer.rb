class LessonSerializer < ActiveModel::Serializer
  attributes :id, :reference, :title, :description, :type, :prerequisite, :downloadable, :can_discuss, :status, :position

  belongs_to :chapter
  belongs_to :content
  belongs_to :additional_resource
end
