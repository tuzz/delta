require "spec_helper"

RSpec.describe Delta::SetOperator do
  def adapt(a, b)
    described_class.adapt(a: a, b: b, identifier: nil)
  end

  it "chooses the best adapter for the collection type" do
    a = Enumerator.new {}
    b = Enumerator.new {}
    expect(adapt(a, b)).to be_a(described_class::Enumerable)

    a = []
    b = []
    expect(adapt(a, b)).to be_a(described_class::Enumerable)

    a = Set.new
    b = Set.new
    expect(adapt(a, b)).to be_a(described_class::Enumerable)

    a = Model.all
    b = Model.all
    expect(adapt(a, b)).to be_a(described_class::ActiveRecord)
  end

  it "falls back to using Enumerable when the types are mixed" do
    a = []
    b = Set.new
    expect(adapt(a, b)).to be_a(described_class::Enumerable)

    a = Model.all
    b = Enumerator.new {}
    expect(adapt(a, b)).to be_a(described_class::Enumerable)
  end
end
