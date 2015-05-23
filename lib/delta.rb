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
    Enumerator.new do |y|

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

  def subtract(a, b)
    a.reject { |e| b.include?(e) }
  end

  attr_reader :from, :to

end
