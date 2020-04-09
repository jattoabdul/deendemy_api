require 'jwt'

module DeenDemy
  class JsonWebToken
    # @return [String]
    def self.encode(payload, expiration = 24.hours.from_now)
      payload = payload.dup
      payload['iat'] = Time.current.to_i
      payload['exp'] = expiration.to_i
      JWT.encode(payload, ENV.fetch('JWT_SECRET'))
    end

    # @return [HashWithIndifferentAccess]
    def self.decode(token, secret: nil)
      secret ||= ENV.fetch('JWT_SECRET')
      HashWithIndifferentAccess.new(JWT.decode(token, secret).first)
    end
  end
end
