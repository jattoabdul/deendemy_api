class Service
  class ServiceError < StandardError; end

  cattr_accessor(:logger) { Rails.logger }
end
