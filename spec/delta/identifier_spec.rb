require "spec_helper"

RSpec.describe Delta::Identifier do
  describe "#identity" do
    it "returns a hash of attributes specified by the initializer" do
      subject = described_class.new([:size, :to_s])
      expect(subject.identity([1, 2])).to eq(size: 2, to_s: "[1, 2]")

      subject = described_class.new([:reverse, :upcase])
      expect(subject.identity("foo")).to eq(reverse: "oof", upcase: "FOO")
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
  end

  describe "#identities" do
    before do
      Model.create!(species: "Pikachu", name: "Zappy", type: "Electric")
      Model.create!(species: "Pidgey", name: "Mr. Peck", type: "Flying")
    end

    after { Model.destroy_all }

    let(:collection) { Model.where(species: %w(Pikachu Pidgey)) }

    it "returns a hash of arrays of attributes specified by the initializer" do
      subject = described_class.new([:species, :name])
      results = subject.identities(collection)

      expect(results).to eq(
        species: %w(Pikachu Pidgey),
        name: ["Zappy", "Mr. Peck"]
      )
    end
  end

  it "caches results for subsequent calls" do
    class SomeObject
      attr_accessor :string

      def initialize(string)
        self.string = string
      end
    end

    foo = SomeObject.new("foo")
    subject = described_class.new([:string])

    expect(subject.identity(foo)).to eq(string: "foo")
    foo.string = "bar"
    expect(subject.identity(foo)).to eq(string: "foo")
  end

  describe "null object" do
    subject { described_class::Null.new }

    describe "#identity" do
      it "returns the given object" do
        object = Object.new
        expect(subject.identity(object)).to eq(object)
      end
    end

    describe "#identities" do
      let!(:pikachu) { Model.create!(species: "Pikachu", name: "Zappy", type: "Electric") }
      let!(:pidgey)  { Model.create!(species: "Pidgey", name: "Mr. Peck", type: "Flying") }

      after { Model.destroy_all }

      let(:collection) { Model.where(species: %w(Pikachu Pidgey)) }

      it "returns the collections' ids in a hash" do
        expect(subject.identities(collection)).to eq(
          id: [pikachu.id, pidgey.id]
        )
      end
    end
  end
end
