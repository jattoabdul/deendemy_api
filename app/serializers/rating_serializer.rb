class RatingSerializer < ActiveModel::Serializer
  attributes :id, :rating, :status, :review, :is_deleted, :created_at, :updated_at

  belongs_to :course, serializer: CourseSerializer
  belongs_to :user, serializer: UserSerializer
end