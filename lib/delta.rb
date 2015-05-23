class Delta
  def initialize(from:, to:, pluck: nil, keys: nil)
    @from  = from
    @to    = to
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
    a.reject do |a_object|
      b.any? do |b_object|
        a_object == b_object
      end
    end
  end

  def intersection(a, b)
    Enumerator.new do |y|
      a.each do |a_object|
        a_identifier = identifier(a_object)

        b.any? do |b_object|
          b_identifier = identifier(b_object)

          if a_identifier == b_identifier
            y.yield [a_object, b_object]
          end
        end
      end
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
