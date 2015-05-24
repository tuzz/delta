require "spec_helper"

RSpec.describe Delta::Plucker do
  let(:pikachu) { Pokemon.new("Pikachu", "Zappy",    "Electric") }
  let(:pidgey)  { Pokemon.new("Pidgey",  "Mr. Peck", "Flying")   }
  let(:raichu)  { Pokemon.new("Raichu",  "Zappy",    "Electric") }

  subject { described_class.new([:name, :type]) }

  it "returns an object with methods specified by the initializer" do
    result = subject.pluck(pikachu)

    expect(result.name).to eq("Zappy")
    expect(result.type).to eq("Electric")
    expect(result).to_not respond_to(:species)
  end

  describe "null object" do
    subject { described_class::Null.new }

    it "returns the given object" do
      object = Object.new
      expect(subject.pluck(object)).to eq(object)
    end
  end
end
