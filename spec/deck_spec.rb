require "./card"
require "./deck"

RSpec.describe Deck do
  describe "#new" do
    it "sets the decks cards" do
      deck = described_class.new
      expect(deck.cards.length).to eq(108)
    end
  end
end
