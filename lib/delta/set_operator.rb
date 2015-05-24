class Delta
  class SetOperator
    def self.adapt(a:, b:, identifier:)
      adapter = Enumerable
      adapter.new(a: a, b: b, identifier: identifier)
    end

    def initialize(a:, b:, identifier:)
      self.a = a.lazy
      self.b = b.lazy
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

    # a - b
    def subtract(a, b)
      fail NotImplementedError, "override me"
    end

    # a & b
    def intersect(a, b)
      fail NotImplementedError, "override me"
    end
  end
end
