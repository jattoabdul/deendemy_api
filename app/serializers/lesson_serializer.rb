class LessonSerializer < ActiveModel::Serializer
  attributes :id, :reference, :title, :description, :assessment_id, :content_id, :additional_resource_id, :type, :prerequisite, :downloadable, :can_discuss, :status, :position

  belongs_to :chapter
  # belongs_to :assessment
end
