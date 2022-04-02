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

  describe "#nigiri?" do
    it "is true when name has Nigiri" do
      expect(Card.new(card_name: "Egg Nigiri")).to be_nigiri
    end
  end

  {
    wasabi?: "Wasabi",
    egg_nigiri?: "Egg Nigiri",
    salmon_nigiri?: "Salmon Nigiri",
    squid_nigiri?: "Squid Nigiri",
    tempura?: "Tempura",
    sashimi?: "Sashimi",
    dumpling?: "Dumpling",
    maki?: "Maki (***)",
    pudding?: "Pudding",
    chopsticks?: "Chopsticks"
  }.each do |method, card_name|
    describe "##{method}" do
      it "is true when name is #{card_name}" do
        expect(Card.new(card_name:).public_send(method)).to eq(true)
      end

      it "is false when name is 'Not #{card_name}'" do
        expect(Card.new(card_name: "Not #{card_name}").public_send(method)).to eq(false)
      end
    end
  end
end
