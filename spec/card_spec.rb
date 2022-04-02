require "spec_helper"

RSpec.describe Card do
  describe "#new" do
    let(:card) do
      described_class.new(card_name: "")
    end

    it "requires a card name" do
      expect {
        described_class.new
      }.to raise_error(ArgumentError, "missing keyword: :card_name")
    end

    it "has a default value of 0" do
      expect(card.value).to eq(0)
    end

    it "has a default maki_value of 0" do
      expect(card.maki_value).to eq(0)
    end
  end

  describe "#name" do
    let(:card_name) { "寿司" }
    let(:card) do
      described_class.new(card_name:, maki_value: 3)
    end

    context "when the name includes 'Maki'" do
      let(:card_name) { "Maki" }
      it "has a * for each maki value" do
        expect(card.name).to eq("Maki(***)")
      end
    end

    it "returns the card name" do
      expect(card.name).to eq("寿司")
    end
  end
end
