class Category
  include Mongoid::Document
  include Eventable
  include Serializable

  # Fields
  field :name, type: String

  # Validations
  validates :name, presence: true, uniqueness: true

  # Hooks/Callbacks
  after_create do
    Event.create(name: 'category.created', eventable: self, data: serialize)
  end
end
