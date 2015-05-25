class Delta
  class SetOperator
    class ActiveRecord < SetOperator
      def self.compatible?(a, b)
        a.is_a?(b.class) && a.class.name.include?("ActiveRecord")
      end

      def initialize(a:, b:, identifiers: nil, changes:)
        super

        self.identifiers = identifiers || [:id]
      end

      private

      def subtract(a_scope, b_scope)
        a = arel_table(a_scope, "a")
        b = arel_table(b_scope, "b")

        query = build_query(a_scope, b_scope, left_join)

        query = query.project(a[Arel.star])
        query = query.where(b[identifiers.first].eq(nil))

        execute(query, a_scope)
      end

      def intersect(a_scope, b_scope)
        return [] if changes.empty?

        a = arel_table(a_scope, "a")
        b = arel_table(b_scope, "b")

        query = build_query(a_scope, b_scope, inner_join)

        query = query.project(Arel.star)
        query = query.where(attribute_clause(a, b))

        execute(query, a_scope)
      end

      def build_query(a_scope, b_scope, join_type)
        a_query = nested_query(a_scope, "a")
        b_query = nested_query(b_scope, "b")

        a = arel_table(a_scope, "a")
        b = arel_table(b_scope, "b")

        query = a.from(a_query)
        query = query.join(b.join(b_query).join_sources, join_type)
        query = query.on(*identity_clauses(a, b))
        query = query.group(*group_clauses(a, b))

        query
      end

      def identity_clauses(a, b)
        identifiers.map { |k| a[k].eq(b[k]) }
      end

      def attribute_clause(a, b)
        changes.map { |k| a[k].not_eq(b[k]) }.inject(&:or)
      end

      def group_clauses(a, _b)
        identifiers.map { |k| a[k] }
      end

      def execute(query, scope)
        scope.model.find_by_sql(query.to_sql)
      end

      def arel_table(scope, name)
        Arel::Table.new(scope.arel_table.name, as: name)
      end

      def nested_query(scope, name)
        Arel.sql("(#{scope.to_sql}) as #{name}")
      end

      def left_join
        Arel::Nodes::OuterJoin
      end

      def inner_join
        Arel::Nodes::InnerJoin
      end
    end
  end
end
