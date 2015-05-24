class Delta
  class SetOperator
    ADAPTERS = [ActiveRecord, Enumerable]

    def self.adapt(a:, b:, identifier:)
      adapter = ADAPTERS.find { |klass| klass.compatible?(a, b) }
      adapter = ADAPTERS.last unless adapter

      adapter.new(a: a, b: b, identifier: identifier)
    end

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

    protected

    attr_accessor :a, :b, :identifier

    private

    # a - b
    def subtract(_a, _b)
      fail NotImplementedError, "override me"
    end

    # a & b
    def intersect(_a, _b)
      fail NotImplementedError, "override me"
    end
  end
end
