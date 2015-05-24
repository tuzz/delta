class Delta
  class Identifier
    def initialize(keys)
      self.keys = keys
    end

    def identity(object)
      cache(object) { Hash[keys.map { |k| [k, object.public_send(k)] }] }
    end

    def identities(collection)
      cache(collection) { Hash[keys.map { |k| [k, collection.pluck(k).uniq] }] }
    end

    private

    attr_accessor :keys

    def cache(key)
      @cache ||= {}
      @cache.key?(key) ? @cache.fetch(key) : @cache[key] = yield
    end

    class Null < Identifier
      def initialize
      end

      def identity(object)
        object
      end

      def identities(collection)
        cache(collection) { { id: collection.pluck(:id) } }
      end
    end
  end
end
