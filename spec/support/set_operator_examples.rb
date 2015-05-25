RSpec.shared_examples "a set operator" do
  describe "#a_minus_b" do
    it "returns the set operation: a - b" do
      subject = described_class.new(
        a: a,
        b: b,
        changes: []
      )

      expect(subject.a_minus_b).to respond_to(:each)
      expect(subject.a_minus_b.to_a).to match_array [pikachu, magikarp]
    end

    it "uses the identifiers to determine object equality" do
      subject = described_class.new(
        a: a,
        b: b,
        identifiers: [:name],
        changes: []
      )

      expect(subject.a_minus_b).to respond_to(:each)
      expect(subject.a_minus_b.to_a).to match_array [magikarp]
    end

    it "works with more than one identifier" do
      subject = described_class.new(
        a: a,
        b: b,
        identifiers: [:name, :species],
        changes: []
      )

      expect(subject.a_minus_b).to respond_to(:each)
      expect(subject.a_minus_b.to_a).to match_array [pikachu, magikarp]
    end
  end

  describe "#b_minus_a" do
    it "returns the set operation: b - a" do
      subject = described_class.new(
        a: a,
        b: b,
        changes: []
      )

      expect(subject.b_minus_a).to respond_to(:each)
      expect(subject.b_minus_a.to_a).to match_array [raichu, butterfree]
    end

    it "uses the identifiers to determine object equality" do
      subject = described_class.new(
        a: a,
        b: b,
        identifiers: [:name],
        changes: []
      )

      expect(subject.b_minus_a).to respond_to(:each)
      expect(subject.b_minus_a.to_a).to match_array [butterfree]
    end

    it "works with more than one identifier" do
      subject = described_class.new(
        a: a,
        b: b,
        identifiers: [:name, :species],
        changes: []
      )

      expect(subject.b_minus_a).to respond_to(:each)
      expect(subject.b_minus_a.to_a).to match_array [raichu, butterfree]
    end
  end

  describe "#intersection" do
    it "returns b from the set operation a & b" do
      subject = described_class.new(
        a: a,
        b: b,
        identifiers: [:name],
        changes: [:species]
      )

      expect(subject.intersection.to_a).to match_array [raichu]
    end

    it "uses the identifiers to determine object equality" do
      subject = described_class.new(
        a: a,
        b: b,
        changes: [:species]
      )

      expect(subject.intersection).to respond_to(:each)
      expect(subject.intersection.to_a).to match_array []
    end

    it "works with more than one identifier" do
      subject = described_class.new(
        a: a,
        b: b,
        identifiers: [:name, :type],
        changes: [:species]
      )

      expect(subject.intersection).to respond_to(:each)
      expect(subject.intersection.to_a).to match_array [raichu]
    end

    it "returns an empty collection if no changes are specified" do
      subject = described_class.new(
        a: a,
        b: b,
        identifiers: [:species],
        changes: []
      )

      expect(subject.intersection.to_a).to match_array []
    end
  end
end
