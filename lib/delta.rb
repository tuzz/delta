class Delta
  def initialize(from:, to:)
    @from = from
    @to = to
  end

  def additions
    Enumerator.new do |y|
      subtract(to, from).each do |element|
        y.yield element
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
        y.yield element
      end
    end
  end

  private

  attr_reader :from, :to

  def subtract(a, b)
    a.reject do |a_element|
      b.any? do |b_element|
        a_element == b_element
      end
    end
  end
end
