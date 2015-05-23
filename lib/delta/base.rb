class Delta
  def initialize(from:, to:, pluck: nil, keys: nil)
    identifier = keys ? Identifier.new(keys) : Identifier::Null.new
    self.set_operator = SetOperator.new(a: from, b: to, identifier: identifier)
    self.plucker = pluck ? Plucker.new(pluck) : Plucker::Null.new
  end

  def additions
    Enumerator.new do |y|
      set_operator.subtract_a_from_b.each do |object|
        y.yield plucker.pluck(object)
      end
    end
  end

  def modifications
    Enumerator.new do |y|
      set_operator.intersection.each do |from_object, to_object|
        to_attributes = plucker.pluck_intersection(from_object, to_object)
        y.yield to_attributes if to_attributes
      end
    end
  end

  def deletions
    Enumerator.new do |y|
      set_operator.subtract_b_from_a.each do |object|
        y.yield plucker.pluck(object)
      end
    end
  end

  private

  attr_accessor :set_operator, :plucker
end
