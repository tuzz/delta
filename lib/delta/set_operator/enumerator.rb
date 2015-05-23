class Delta
  module SetOperator
    class Enumerator
      def initialize(a:, b:, identifier:)
        self.a = a
        self.b = b
        self.identifier = identifier
      end

      def subtract_a_from_b
        subtract(b, a)
      end

      def subtract_b_from_a
        subtract(a, b)
      end

      def intersection
        intersect(a, b)
      end

      private

      attr_accessor :a, :b, :identifier

      def subtract(a, b)
        a.reject { |a_object| other_object(b, a_object) }
      end

      def intersect(a, b)
        a.map { |a_object| [a_object, other_object(b, a_object)] }
        .select { |_, b_object| b_object }
      end

      def other_object(collection, object)
        identity = identifier.identity(object)

        collection.find do |other_object|
          identity == identifier.identity(other_object)
        end
      end
    end
  end
end
