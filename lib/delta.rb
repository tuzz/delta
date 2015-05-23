class Delta
  def initialize(from:, to:, pluck: nil, keys: nil)
    @from  = from.lazy
    @to    = to.lazy
    @pluck = pluck
    @keys  = keys
  end

  def additions
    Enumerator.new do |y|
      subtract(to, from).each do |object|
        y.yield attributes(object)
      end
    end
  end

  def modifications
    Enumerator.new do |y|
      intersection(from, to).each do |from_object, to_object|
        from_attributes = attributes(from_object)
        to_attributes = attributes(to_object)

        y.yield to_attributes unless from_attributes == to_attributes
      end
    end
  end

  def deletions
    Enumerator.new do |y|
      subtract(from, to).each do |object|
        y.yield attributes(object)
      end
    end
  end

  private

  attr_reader :from, :to, :pluck, :keys

  # TODO: Inject a collection adapter?
  def subtract(a, b)
    a.reject { |a_object| other_object(b, a_object) }
  end

  def intersection(a, b)
    a.map { |a_object| [a_object, other_object(b, a_object)] }.
      select { |_, b_object| b_object }
  end

  def other_object(collection, object)
    identifier = identifier(object)

    collection.find do |other_object|
      identifier == identifier(other_object)
    end
  end

  def identifier(object)
    return object unless keys

    identifier = keys.map { |k| object.public_send(k) }
    struct.new(*identifier)
  end

  def attributes(object)
    return object unless pluck

    attributes = pluck.map { |k| object.public_send(k) }
    struct.new(*attributes)
  end

  def struct
    @struct ||= Struct.new(*pluck)
  end
end
