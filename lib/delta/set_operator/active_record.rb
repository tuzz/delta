class Delta
  class SetOperator
    class ActiveRecord < SetOperator
      def self.compatible?(a, b)
        a.is_a?(b.class) && a.class.name.include?("ActiveRecord")
      end

      private

      def subtract(a, b)
        a.where.not(identifier.identities(b))
      end

      def intersect(a, b)
        keys = identity_keys(a)

        a_records = left_of_intersection(a, b)
        a_records = unique_records(a_records, keys)

        Enumerator.new do |y|
          a_records.each do |record|
            y.yield find_pair!(record, keys)
          end
        end
      end

      def identity_keys(collection)
        identifier.identities(collection).keys
      end

      def left_of_intersection(a, b)
        b_identities = identifier.identities(b)
        a.where(b_identities)
      end

      def unique_records(collection, keys)
        collection.select(*keys).distinct
      end

      def find_pair!(record, keys)
        attributes = record.slice(*keys)
        [a.find_by!(attributes), b.find_by!(attributes)]
      end
    end
  end
end
