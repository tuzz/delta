require "spec_helper"

RSpec.describe Delta::SetOperator::Enumerable do
  let(:pikachu)    { Pokemon.new("Pikachu",    "Zappy",    "Electric") }
  let(:pidgey)     { Pokemon.new("Pidgey",     "Mr. Peck", "Flying")   }
  let(:magikarp)   { Pokemon.new("Magikarp",   "Splashy",  "Water")    }
  let(:raichu)     { Pokemon.new("Raichu",     "Zappy",    "Electric") }
  let(:butterfree) { Pokemon.new("Butterfree", "Flappy",   "Flying")   }

  let(:a) { [pikachu, pidgey, magikarp].to_enum  }
  let(:b) { [raichu, pidgey, butterfree].to_enum }

  describe "#subtract_a_from_b" do
    it "returns the set operation: b - a" do
      identifier = Delta::Identifier::Null.new
      subject = described_class.new(a: a, b: b, identifier: identifier)

      expect(subject.subtract_a_from_b).to be_an(Enumerator)
      expect(subject.subtract_a_from_b.to_a).to eq [raichu, butterfree]
    end

    it "uses the identifier to determine object equality" do
      identifier = Delta::Identifier.new([:name])
      subject = described_class.new(a: a, b: b, identifier: identifier)

      expect(subject.subtract_a_from_b).to be_an(Enumerator)
      expect(subject.subtract_a_from_b.to_a).to eq [butterfree]
    end
  end

  describe "#subtract_b_from_a" do
    it "returns the set operation: a - b" do
      identifier = Delta::Identifier::Null.new
      subject = described_class.new(a: a, b: b, identifier: identifier)

      expect(subject.subtract_b_from_a).to be_an(Enumerator)
      expect(subject.subtract_b_from_a.to_a).to eq [pikachu, magikarp]
    end

    it "uses the identifier to determine object equality" do
      identifier = Delta::Identifier.new([:name])
      subject = described_class.new(a: a, b: b, identifier: identifier)

      expect(subject.subtract_b_from_a).to be_an(Enumerator)
      expect(subject.subtract_b_from_a.to_a).to eq [magikarp]
    end
  end

  describe "#intersection" do
    it "returns both a and b for the set operation: a & b" do
      identifier = Delta::Identifier::Null.new
      subject = described_class.new(a: a, b: b, identifier: identifier)

      expect(subject.intersection).to be_an(Enumerator)
      expect(subject.intersection.to_a).to eq [[pidgey, pidgey]]
    end

    it "uses the identifier to determine object equality" do
      identifier = Delta::Identifier.new([:name])
      subject = described_class.new(a: a, b: b, identifier: identifier)

      expect(subject.intersection).to be_an(Enumerator)
      expect(subject.intersection.to_a).to eq [
        [pikachu, raichu],
        [pidgey, pidgey]
      ]
    end
  end

end
