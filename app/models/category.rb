class Category
  include Mongoid::Document

  # Fields
  field :name, type: String

  # Validations
  validates :name, presence: true, uniqueness: true
end
