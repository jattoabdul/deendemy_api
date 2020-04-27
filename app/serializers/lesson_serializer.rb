class LessonSerializer < ActiveModel::Serializer
  attributes :id, :reference, :title, :description, :assessment_id, :content, :additional_resource, :type, :prerequisite, :downloadable, :can_discuss, :is_last

  belongs_to :chapter
  # belongs_to :assessment
end
