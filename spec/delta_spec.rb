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

end
