class Delta
  def initialize(from:, to:, pluck: nil, keys: nil)
    @from       = from.lazy
    @to         = to.lazy
    @plucker    = pluck ? Plucker.new(pluck) : Plucker::Null.new
    @identifier = keys ? Identifier.new(keys) : Identifier::Null.new
  end

  def additions
    Enumerator.new do |y|
      subtract(to, from).each do |object|
        y.yield plucker.pluck(object)
      end
    end
  end

  def modifications
    Enumerator.new do |y|
      intersection(from, to).each do |from_object, to_object|
        to_attributes = plucker.pluck_intersection(from_object, to_object)
        y.yield to_attributes if to_attributes
      end
    end
  end

  def deletions
    Enumerator.new do |y|
      subtract(from, to).each do |object|
        y.yield plucker.pluck(object)
      end
    end
  end

  private

  attr_reader :from, :to, :plucker, :identifier

  # TODO: Inject a collection adapter?
  def subtract(a, b)
    a.reject { |a_object| other_object(b, a_object) }
  end

  def intersection(a, b)
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
