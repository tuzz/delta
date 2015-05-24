require "spec_helper"

RSpec.describe Delta::SetOperator do

  def adapt(a, b)
    subject.adapt(a: a, b: b, identifier: nil)
  end

  it "chooses the best adapter for the collection type" do
    a, b = Enumerator.new {}, Enumerator.new {}
    expect(adapt(a, b)).to be_a(described_class::Enumerable)

    a, b = [], []
    expect(adapt(a, b)).to be_a(described_class::Enumerable)

    a, b = Set.new, Set.new
    expect(adapt(a, b)).to be_a(described_class::Enumerable)

    a, b = Model.all, Model.all
    expect(adapt(a, b)).to be_a(described_class::Enumerable)
  end

  it "falls back to using Enumerable when the types are mixed" do
    a, b = [], Set.new
    expect(adapt(a, b)).to be_a(described_class::Enumerable)

    a, b = Model.all, Enumerator.new {}
    expect(adapt(a, b)).to be_a(described_class::Enumerable)
  end

end
