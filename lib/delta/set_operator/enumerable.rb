class Delta
  class SetOperator
    class Enumerable < SetOperator
      def self.compatible?(_a, _b)
        true
      end

      def initialize(a:, b:, identifiers: nil, changes:)
        super

        self.identifiers = identifiers || [:object_id]
        self.a = a.lazy
        self.b = b.lazy
      end

      private

      def subtract(a, b)
        a.reject { |a_object| other_object(b, a_object) }
      end

      def intersect(a, b)
        return [] if changes.empty?

        pairs = pairs(a, b).reject do |a_object, b_object|
          attributes(a_object) == attributes(b_object)
        end

        pairs.map { |_, b_object| b_object }
      end

      def pairs(a, b)
        a.map { |a_object| [a_object, other_object(b, a_object)] }
         .select { |_, b_object| b_object }
      end

      def other_object(collection, object)
        identity = identity(object)

        collection.find do |other_object|
          identity == identity(other_object)
        end
      end

      def identity(object)
        cache(:identity, object) do
          identifiers.map { |m| object.public_send(m) }
        end
      end

      def attributes(object)
        cache(:attributes, object) do
          changes.map { |m| object.public_send(m) }
        end
      end

      def cache(name, key)
        @cache ||= {}
        @cache[name] ||= {}

        if @cache[name].key?(key)
          @cache[name][key]
        else
          @cache[name][key] = yield
        end
      end
    end
  end
end
