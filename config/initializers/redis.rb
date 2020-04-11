require 'redis'

REDIS = Redis.new({ url: URI.join(ENV.fetch('REDIS_URL') { 'redis://127.0.0.1:6379' }), driver: :hiredis })
