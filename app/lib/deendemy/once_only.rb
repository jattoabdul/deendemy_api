module Deendemy
  class OnceOnly
    # Performs a block only once using Redis as a store
    # @param key [String, Array]
    # @param member [String]
    # @return [Boolean]
    def self.with(key, member)
      yield if REDIS.sadd(['once', Array.wrap(key)].join(':'), member)
    end
  end
end
