class Delta
  class Identifier
    def initialize(keys)
      self.keys = keys
    end

    def identity(object)
      cache(object) { keys.map { |k| object.public_send(k) } }
    end

    private

    attr_accessor :keys

    def cache(key)
      @cache ||= {}
      @cache.key?(key) ? @cache.fetch(key) : @cache[key] = yield
    end

    class Null
      def identity(object)
        object
      end
    end
  end
end
