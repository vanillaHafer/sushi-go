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

    context "without a name of Maki and a maki value > 0" do
      let(:card) do
        described_class.new(card_name: "Sushimi", maki_value: 6)
      end

      it "does not change the name" do
        expect(card.name).to eq("Sushimi")
      end
    end

    context "with a name of Maki and a maki value > 0" do
      let(:card) do
        described_class.new(card_name: "Maki", maki_value: 6)
      end

      it "appends * to the name" do
        expect(card.name).to eq("Maki (******)")
      end
    end
  end

  describe "#name" do
    let(:card_name) { "寿司" }
    let(:card) do
      described_class.new(card_name:)
    end

    it "returns the card_name" do
      expect(card.name).to eq("寿司")
    end
  end

  describe "#maki?" do
    context "when name starts with 'Maki'" do
      let(:card) do
        described_class.new(card_name: "Maki", maki_value: 6)
      end

      it "is true" do
        expect(card).to be_maki
      end
    end

    context "when name does not start with 'Maki'" do
      let(:card) do
        described_class.new(card_name: "Egg Nigiri", maki_value: 6)
      end

      it "is false" do
        expect(card).not_to be_maki
      end
    end
  end

  describe "#pudding?" do
    context "when name starts with 'Pudding'" do
      let(:card) { described_class.new(card_name: "Pudding") }

      it "is true" do
        expect(card).to be_pudding
      end
    end

    context "when name does not start with 'Pudding'" do
      let(:card) { described_class.new(card_name: "Not Pudding") }

      it "is false" do
        expect(card).not_to be_pudding
      end
    end
  end
end
