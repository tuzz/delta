class Delta
  def initialize(from:, to:, pluck: nil)
    @from = from
    @to = to
    @pluck = pluck
  end

  def additions
    Enumerator.new do |y|
      subtract(to, from).each do |element|
        y.yield pluck_fields(element)
      end
    end
  end

  def modifications
    Enumerator.new do |_y|

    end
  end

  def deletions
    Enumerator.new do |y|
      subtract(from, to).each do |element|
        y.yield pluck_fields(element)
      end
    end
  end

  private

  attr_reader :from, :to, :pluck

  # TODO: Inject a collection adapter?
  def subtract(a, b)
    a.reject do |a_element|
      b.any? do |b_element|
        a_element == b_element
      end
    end
  end

  def pluck_fields(element)
    return element unless pluck

    fields = pluck.map { |p| element.public_send(p) }
    struct.new(*fields)
  end

  def struct
    @struct ||= Struct.new(*pluck)
  end
end
