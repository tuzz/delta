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
    expect(delta.deletions.to_a).to eq [pikachu, magikarp]
  end

  it "works for the pluck example in the readme" do
    delta = described_class.new(from: from, to: to, pluck: [:name, :species])

    expect(delta.additions.count).to eq(2)
    expect(delta.deletions.count).to eq(2)

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

  it "works for the modification example in the readme (option 1)" do
    # Add the equality method to Pokemon.
    Pokemon.class_eval do
      def ==(other)
        name == other.name
      end
    end

    delta = described_class.new(from: from, to: to, pluck: [:species, :name])

    expect(delta.additions.count).to eq 1
    expect(delta.modifications.count).to eq 1
    expect(delta.deletions.count).to eq 1

    addition = delta.additions.first
    expect(addition.species).to eq "Butterfree"
    expect(addition.name).to eq "Flappy"

    modification = delta.modifications.first
    expect(modification.species).to eq "Raichu"
    expect(modification.name).to eq "Zappy"

    deletion = delta.deletions.first
    expect(deletion.species).to eq "Magikarp"
    expect(deletion.name).to eq "Splashy"

    # Remove the equality method from Pokemon.
    Pokemon.class_eval do
      def ==(other)
        object_id == other.object_id
      end
    end
  end

  it "works for the modification example in the readme (option 2)" do
    delta = described_class.new(
      from: from,
      to: to,
      pluck: [:species, :name],
      keys: [:name]
    )

    expect(delta.additions.count).to eq 1
    expect(delta.modifications.count).to eq 1
    expect(delta.deletions.count).to eq 1

    addition = delta.additions.first
    expect(addition.species).to eq "Butterfree"
    expect(addition.name).to eq "Flappy"

    modification = delta.modifications.first
    expect(modification.species).to eq "Raichu"
    expect(modification.name).to eq "Zappy"

    deletion = delta.deletions.first
    expect(deletion.species).to eq "Magikarp"
    expect(deletion.name).to eq "Splashy"
  end

  it "works as specified when no pluck attributes are specified" do
    delta = described_class.new(from: from, to: to, keys: [:name])

    expect(delta.additions.count).to eq 1
    expect(delta.modifications.count).to eq 2
    expect(delta.deletions.count).to eq 1

    first, second = *delta.modifications

    expect(first.species).to eq "Raichu"
    expect(first.name).to eq "Zappy"
    expect(first.type).to eq "Electric"

    expect(second.species).to eq "Pidgey"
    expect(second.name).to eq "Mr. Peck"
    expect(second.type).to eq "Flying"
  end

  it "worls for the composite key example in the readme" do
    butterfree.name = "FANG!"
    magikarp.name = "FANG!"

    delta = Delta.new(
      from: [pikachu, pidgey, magikarp],
      to: [raichu, pidgey, butterfree],
      pluck: [:species, :name, :type],
      keys: [:name, :type]
    )

    expect(delta.additions.count).to eq 1
    expect(delta.modifications.count).to eq 1
    expect(delta.deletions.count).to eq 1

    addition = delta.additions.first
    expect(addition.species).to eq("Butterfree")
    expect(addition.name).to eq("FANG!")
    expect(addition.type).to eq("Flying")

    modification = delta.modifications.first
    expect(modification.species).to eq("Raichu")
    expect(modification.name).to eq("Zappy")
    expect(modification.type).to eq("Electric")

    deletion = delta.deletions.first
    expect(deletion.species).to eq("Magikarp")
    expect(deletion.name).to eq("FANG!")
    expect(deletion.type).to eq("Water")
  end

  it "works for the many-to-one example in the readme" do
    delta = Delta.new(
      from: [pikachu, pidgey, magikarp],
      to: [raichu, pidgey, butterfree],
      keys: [:type],
      pluck: [:type]
    )

    expect(delta.additions.count).to eq 0
    expect(delta.modifications.count).to eq 0
    expect(delta.deletions.count).to eq 1

    deletion = delta.deletions.first
    expect(deletion.type).to eq("Water")
  end

end
