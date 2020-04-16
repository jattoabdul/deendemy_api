class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :data, :eventable_type

  attribute :created_at do
    object.created_at.utc
  end
end
