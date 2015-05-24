class Delta
  module SetOperator
    def self.adapt(a:, b:, identifier:)
      adapter = Enumerable
      adapter.new(a: a, b: b, identifier: identifier)
    end
  end
end
