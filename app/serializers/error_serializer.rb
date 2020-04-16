module ErrorSerializer

  def self.serialize(errors)
    return if errors.nil?

    json = {}
    new_hash = errors.to_hash(true).map do |k, v|
      v.map do |msg|
        { field: k, message: msg }
      end
    end.flatten
    json[:errors] = new_hash
    json
  end
end
