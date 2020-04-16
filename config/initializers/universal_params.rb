module ActionController
  class Parameters
    def universal
      @universal = true
      @parameters.deep_transform_keys!{ |k| k.is_a?(String) ? k.underscore : k }
      self
    end
  end
end
