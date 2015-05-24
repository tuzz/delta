RSpec.shared_examples "integration specs" do
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

  it "works for the modification example in the readme" do
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

  it "falls back to object equality when no pluck attributes are specified" do
    # Note: pidgey is the same object in both collections.

    delta = described_class.new(from: from, to: to, keys: [:name])

    expect(delta.additions.count).to eq 1
    expect(delta.modifications.count).to eq 1
    expect(delta.deletions.count).to eq 1

    modification = delta.modifications.first
    expect(modification.species).to eq "Raichu"
    expect(modification.name).to eq "Zappy"
    expect(modification.type).to eq "Electric"
  end

  it "works for the composite key example in the readme" do
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
