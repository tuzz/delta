class Delta
  class SetOperator
    ADAPTERS = [ActiveRecord, Enumerable].freeze

    def self.adapt(a:, b:, identifiers:, changes:)
      adapter = ADAPTERS.find { |klass| klass.compatible?(a, b) }
      adapter = ADAPTERS.last unless adapter

      adapter.new(
        a: a,
        b: b,
        identifiers: identifiers,
        changes: changes
      )
    end

    def initialize(a:, b:, identifiers:, changes:)
      self.a = a
      self.b = b
      self.identifiers = identifiers
      self.changes = changes
    end

    def a_minus_b
      subtract(a, b)
    end

    def b_minus_a
      subtract(b, a)
    end

    def intersection
      intersect(a, b)
    end

    protected

    attr_accessor :a, :b, :identifiers, :changes

    private

    # a - b
    def subtract(_a, _b)
      raise NotImplementedError, "override me"
    end

    # a & b
    def intersect(_a, _b)
      raise NotImplementedError, "override me"
    end
  end
end
