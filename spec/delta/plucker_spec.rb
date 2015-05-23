require "spec_helper"

RSpec.describe Delta::Plucker do
  let(:pikachu) { Pokemon.new("Pikachu", "Zappy",    "Electric") }
  let(:pidgey)  { Pokemon.new("Pidgey",  "Mr. Peck", "Flying")   }
  let(:raichu)  { Pokemon.new("Raichu",  "Zappy",    "Electric") }

  subject { described_class.new([:name, :type]) }

  describe "#pluck" do
    it "returns an object with methods specified by the initializer" do
      result = subject.pluck(pikachu)

      expect(result.name).to eq("Zappy")
      expect(result.type).to eq("Electric")
      expect(result).to_not respond_to(:species)
    end
  end

  describe "#pluck_intersection" do
    context "when the resulting attributes are equal" do
      let(:args) { [pikachu, raichu] }

      it "returns nil" do
        result = subject.pluck_intersection(*args)
        expect(result).to be_nil
      end
    end

    context "whent the resulting attributes are not equal" do
      let(:args) { [pikachu, pidgey] }

      it "returns the an object based on the to_object" do
        result = subject.pluck_intersection(*args)

        expect(result.name).to eq("Mr. Peck")
        expect(result.type).to eq("Flying")
        expect(result).to_not respond_to(:species)
      end
    end
  end

  describe "null object" do
    subject { described_class::Null.new }

    describe "#pluck" do
      it "returns the given object" do
        object = Object.new
        expect(subject.pluck(object)).to eq(object)
      end
    end

    describe "#pluck_intersection" do
      it "returns the given to_object" do
        from_object = Object.new
        to_object = Object.new

        result = subject.pluck_intersection(from_object, to_object)
        expect(result).to eq(to_object)
      end
    end
  end
end
