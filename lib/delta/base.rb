class Delta
  def initialize(from:, to:, pluck: nil, keys: nil)
    identifier = keys ? Identifier.new(keys) : Identifier::Null.new
    self.set = SetOperator.new(a: from, b: to, identifier: identifier)
    self.plucker = pluck ? Plucker.new(pluck) : Plucker::Null.new
  end

  def additions
    Enumerator.new do |y|
      set.subtract_a_from_b.each do |b|
        y.yield plucker.pluck(b)
      end
    end
  end

  def modifications
    Enumerator.new do |y|
      set.intersection.each do |a, b|
        b_attributes = plucker.pluck_intersection(a, b)
        y.yield b_attributes if b_attributes
      end
    end
  end

  def deletions
    Enumerator.new do |y|
      set.subtract_b_from_a.each do |a|
        y.yield plucker.pluck(a)
      end
    end
  end

  private

  attr_accessor :set, :plucker
end
