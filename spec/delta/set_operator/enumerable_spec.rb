require "spec_helper"

RSpec.describe Delta::SetOperator::Enumerable do
  let(:pikachu)    { Pokemon.new("Pikachu",    "Zappy",    "Electric") }
  let(:pidgey)     { Pokemon.new("Pidgey",     "Mr. Peck", "Flying")   }
  let(:magikarp)   { Pokemon.new("Magikarp",   "Splashy",  "Water")    }
  let(:raichu)     { Pokemon.new("Raichu",     "Zappy",    "Electric") }
  let(:butterfree) { Pokemon.new("Butterfree", "Flappy",   "Flying")   }

  let(:a) { [pikachu, pidgey, magikarp].to_enum  }
  let(:b) { [raichu, pidgey, butterfree].to_enum }

  let(:expected_enumerator_class) { Enumerator }

  it_behaves_like "a set operator"

  describe "non-functional requirements" do
    class OneTimeOnly
      def initialize(string)
        @string = string
      end

      def something
        fail "Won't get fooled again" if @fooled_me_once
        @fooled_me_once = true
        @string
      end
    end

    it "does not repeatable call methods on objects" do
      object = OneTimeOnly.new("something")
      expect(object.something).to eq("something")
      expect { object.something }.to raise_error, "The test setup is wrong."

      identifier = Delta::Identifier.new([:something])
      foo1 = OneTimeOnly.new("foo")
      foo2 = OneTimeOnly.new("foo")
      bar  = OneTimeOnly.new("bar")

      subject = described_class.new(
        a: [foo1],
        b: [bar, foo2],
        identifier: identifier
      )

      expect(subject.subtract_a_from_b).to be_an(Enumerator)

      expect(subject.subtract_a_from_b.to_a).to eq [bar]
      expect(subject.subtract_b_from_a.to_a).to eq []
      expect(subject.intersection.to_a).to eq [[foo1, foo2]]
    end
  end
end
