class ProgressSerializer < ActiveModel::Serializer
  attributes :id, :course_id, :lesson_id, :enrollment_id, :status, :updated_at
end
