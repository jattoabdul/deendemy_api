ActionController::Renderers.add :resource do |resource, options|
  serialize_options = Hash(options).slice(:include, :fields, :class_name)
  self.content_type ||= Mime[:json]
  SerializableResource.serialize(resource, serialize_options).to_json
end
