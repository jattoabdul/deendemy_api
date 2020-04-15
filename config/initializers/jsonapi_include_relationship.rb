module JSONAPI::Serializable::IncludeRelationship
  def include_relation(name, options = {}, &block)
    attribute(options[:as] || name) do
      relation = @object.send(name)

      relation = yield relation if block_given?

      if relation.respond_to?(:to_ary)
        Array(relation).map { |r| r.serialize(options) }
      elsif relation
        relation.serialize(options)
      else
        nil
      end
    end
  end
end

JSONAPI::Serializable::Resource.extend(JSONAPI::Serializable::IncludeRelationship)
