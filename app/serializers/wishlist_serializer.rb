class WishlistSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :user
  has_many :items
end
