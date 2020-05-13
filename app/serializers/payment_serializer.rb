class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :tax_rate, :status, :processor, :comment, :reference, :paid_at

  belongs_to :user, serializer: UserSerializer
  has_many :enrollments

  attribute :subtotal do
    object.subtotal.cents
  end
  attribute :total do
    object.total.cents
  end
  attribute :tax do
    object.tax.cents
  end
  attribute :formated_subtotal do
    object.subtotal.format
  end
  attribute :formated_total do
    object.total.format
  end
  attribute :currency do
    object.currency.iso_code
  end
end
