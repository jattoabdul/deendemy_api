module Serializable
  extend ActiveSupport::Concern

  def self.serialize
    ActiveModelSerializers::SerializableResource.new(self).as_json
  end

  def serialize
    ActiveModelSerializers::SerializableResource.new(self).as_json
  end
end