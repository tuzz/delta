require "spec_helper"

RSpec.describe Delta::Identifier do

  it "returns an array of attributes specified by the initializer" do
    subject = described_class.new([:size, :to_s])
    expect(subject.identity([1, 2])).to eq([2, "[1, 2]"])

    subject = described_class.new([:reverse, :upcase])
    expect(subject.identity("foo")).to eq(%w(oof FOO))
  end

  it "cannot call private methods on the object" do
    class SomethingWithAPrivateMethod
      private

      def a_private_method
      end
    end

    subject = described_class.new([:a_private_method])

    expect { subject.identity(SomethingWithAPrivateMethod.new) }
      .to raise_error(NoMethodError)
  end

  it "caches the result for subsequent calls" do
    class SomeObject
      attr_accessor :string

      def initialize(string)
        self.string = string
      end
    end

    foo = SomeObject.new("foo")
    subject = described_class.new([:string])

    expect(subject.identity(foo)).to eq(["foo"])
    foo.string = "bar"
    expect(subject.identity(foo)).to eq(["foo"])
  end

  describe "null object" do
    subject { described_class::Null.new }

    it "returns the given object" do
      object = Object.new
      expect(subject.identity(object)).to eq(object)
    end
  end

end
