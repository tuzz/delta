require "spec_helper"

RSpec.describe Delta do
  let(:pikachu)    { Pokemon.new("Pikachu",    "Zappy",    "Electric") }
  let(:pidgey)     { Pokemon.new("Pidgey",     "Mr. Peck", "Flying")   }
  let(:magikarp)   { Pokemon.new("Magikarp",   "Splashy",  "Water")    }
  let(:raichu)     { Pokemon.new("Raichu",     "Zappy",    "Electric") }
  let(:butterfree) { Pokemon.new("Butterfree", "Flappy",   "Flying")   }

  let(:from) { [pikachu, pidgey, magikarp].to_enum  }
  let(:to)   { [raichu, pidgey, butterfree].to_enum }

  it "works for the simple example in the readme" do
    delta = described_class.new(from: from, to: to)

    expect(delta.additions).to be_an(Enumerator)
    expect(delta.modifications).to be_an(Enumerator)
    expect(delta.deletions).to be_an(Enumerator)

    expect(delta.additions.to_a).to eq [raichu, butterfree]
    expect(delta.modifications.to_a).to eq []
    expect(delta.deletions.to_a).to eq [pikachu, magikarp]
  end

  it "works for the pluck example in the readme" do
    delta = described_class.new(from: from, to: to, pluck: [:name, :species])

    expect(delta.additions.count).to eq 2
    expect(delta.modifications.count).to eq 0
    expect(delta.deletions.count).to eq 2

    first, second = *delta.additions

    expect(first.name).to eq("Zappy")
    expect(first.species).to eq("Raichu")
    expect(first).to_not respond_to(:type)

    expect(second.name).to eq("Flappy")
    expect(second.species).to eq("Butterfree")
    expect(second).to_not respond_to(:type)

    first, second = *delta.deletions

    expect(first.name).to eq("Zappy")
    expect(first.species).to eq("Pikachu")
    expect(first).to_not respond_to(:type)

    expect(second.name).to eq("Splashy")
    expect(second.species).to eq("Magikarp")
    expect(second).to_not respond_to(:type)
  end

end
