RSpec.shared_examples "integration specs" do
  it "works for the simple example in the readme", foo: true do
    delta = described_class.new(from: from, to: to)

    expect(delta.additions).to be_an(Enumerator)
    expect(delta.modifications).to be_an(Enumerator)
    expect(delta.deletions).to be_an(Enumerator)

    expect(delta.additions.to_a).to eq [raichu, butterfree]
    expect(delta.modifications.to_a).to eq []
    expect(delta.deletions.to_a).to eq [pikachu, magikarp]
  end

  it "works for the identifiers example in the readme" do
    delta = described_class.new(from: from, to: to, identifiers: [:name])

    expect(delta.additions.to_a).to eq [butterfree]
    expect(delta.modifications.to_a).to eq []
    expect(delta.deletions.to_a).to eq [magikarp]
  end

  it "works for the modification example in the readme" do
    delta = described_class.new(from: from, to: to, identifiers: [:name], changes: [:species])

    expect(delta.additions.to_a).to eq [butterfree]
    expect(delta.modifications.to_a).to eq [raichu]
    expect(delta.deletions.to_a).to eq [magikarp]
  end

  it "works for the composite key example in the readme" do
    butterfree.update(name: "FANG!")
    magikarp.update(name: "FANG!")

    delta = described_class.new(
      from: from,
      to: to,
      identifiers: [:name, :type],
      changes: [:species]
    )

    expect(delta.additions.to_a).to eq [butterfree]
    expect(delta.modifications.to_a).to eq [raichu]
    expect(delta.deletions.to_a).to eq [magikarp]
  end

  it "works for the many-to-one example in the readme" do
    delta = described_class.new(from: from, to: to, identifiers: [:type])

    expect(delta.additions.to_a).to eq []
    expect(delta.modifications.to_a).to eq []
    expect(delta.deletions.to_a).to eq [magikarp]
  end
end
