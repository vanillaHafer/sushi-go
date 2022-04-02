require "spec_helper"

RSpec.describe Card do
  describe "#new" do
    it "requires a card name" do
      expect {
        described_class.new
      }.to raise_error(ArgumentError, "missing keyword: :card_name")
    end

    it "has a default value of 0" do
      expect(described_class.new(card_name: "").value).to eq(0)
    end

    it "has a default maki_value of 0" do
      expect(described_class.new(card_name: "").maki_value).to eq(0)
    end
  end
end
