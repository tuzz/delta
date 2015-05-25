class Delta
  def initialize(from:, to:, identifiers: nil, changes: [])
    self.set = SetOperator.adapt(
      a: from,
      b: to,
      identifiers: identifiers,
      changes: changes
    )
  end

  def additions
    Enumerator.new do |y|
      set.b_minus_a.each do |b|
        y.yield b
      end
    end
  end

  def modifications
    Enumerator.new do |y|
      set.intersection.each do |b|
        y.yield b
      end
    end
  end

  def deletions
    Enumerator.new do |y|
      set.a_minus_b.each do |a|
        y.yield a
      end
    end
  end

  private

  attr_accessor :set
end
