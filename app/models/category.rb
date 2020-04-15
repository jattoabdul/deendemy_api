class Category
  include Mongoid::Document
  include SerializableResource

  # Fields
  field :name, type: String
end
