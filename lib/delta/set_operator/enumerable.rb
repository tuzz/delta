class Delta
  class SetOperator
    class Enumerable < SetOperator
      private

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
