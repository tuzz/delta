require "spec_helper"

RSpec.describe Delta do
  let(:pikachu)    { Pokemon.new("Pikachu",    "Zappy",    29, "Electric") }
  let(:pidgey)     { Pokemon.new("Pidgey",     "Mr. Peck", 07, "Flying")   }
  let(:magikarp)   { Pokemon.new("Magikarp",   "Splashy",  05, "Water")    }
  let(:raichu)     { Pokemon.new("Raichu",     "Zappy",    30, "Electric") }
  let(:butterfree) { Pokemon.new("Butterfree", "Flappy",   20, "Flying")   }

  it "works for the simple example in the readme" do
    delta = described_class.new(
      from: [pikachu, pidgey, magikarp].to_enum,
      to: [raichu, pidgey, butterfree].to_enum
    )

    expect(delta.additions).to be_an(Enumerator)
    expect(delta.modifications).to be_an(Enumerator)
    expect(delta.deletions).to be_an(Enumerator)

    expect(delta.additions.to_a).to eq [raichu, butterfree]
    expect(delta.modifications.to_a).to eq []
    expect(delta.deletions.to_a).to eq [pikachu, magikarp]
  end

end
