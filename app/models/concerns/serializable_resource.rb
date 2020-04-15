module SerializableResource
  class MissingSerializable < StandardError; end

  def self.serialize(resource, options = nil)
    if resource.respond_to?(:to_ary)
      Array(resource).map { |r| r.serialize(options) }
    else
      resource.serialize(options)
    end
  end

  def serialize(options = nil)
    class_name = Hash(options)[:class_name]
    serializable(class_name).as_jsonapi(Hash(options).slice(:include, :fields))[:attributes]
  end

  def serializable(class_name = nil)
    raise MissingSerializable, "Class not found: #{serializable_class_name(class_name)}" unless serializable?(class_name)

    serializable_class(class_name).new(object: self)
  end

  def serializable?(class_name = nil)
    serializable_class_name(class_name).safe_constantize.present?
  end

  private

  def serializable_class(class_name = nil)
    serializable_class_name(class_name).constantize
  end

  def serializable_class_name(class_name = nil)
    # Note: this could be configurable if need be
    class_name || "Serializable#{self.class.name.demodulize}"
  end
end
