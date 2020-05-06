class CartSerializer < ActiveModel::Serializer
  attributes :id, :expires_on

  belongs_to :user
  has_many :items

  attribute :sub_total do
    object.sub_total.cents
  end
  attribute :formated_sub_total do
    object.sub_total.format
  end
  attribute :sub_total_currency do
    object.sub_total.currency.iso_code
  end
end
