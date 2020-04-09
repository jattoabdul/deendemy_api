require 'redis'

REDIS = Redis.new({ url: URI.join(ENV.fetch('REDIS_URL') { 'redis://localhost:6379' }), driver: :hiredis })
