class SerializableCategory < JSONAPI::Serializable::Resource
  type :categories
  attributes :_id, :name
end
