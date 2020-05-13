class EnrollmentSerializer < ActiveModel::Serializer
  attributes :id, :reference, :payment_id, :cancel_reason, :status, :progress, :is_deleted

  belongs_to :course, serializer: CourseDetailSerializer
  belongs_to :learner, serializer: UserSerializer

  attribute :payment_reference do
    object.payment.reference
  end
end
