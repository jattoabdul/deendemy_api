class AssessmentSerializer < ActiveModel::Serializer
  attributes :id, :reference, :title, :description, :type, :prerequisite, :downloadable, :can_discuss, :status, :position, :questions

  belongs_to :chapter
  belongs_to :additional_resource
end
