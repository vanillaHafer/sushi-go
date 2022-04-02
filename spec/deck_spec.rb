require "spec_helper"

RSpec.describe Deck do
  describe "#new" do
    it "sets the decks cards" do
      deck = described_class.new
      expect(deck.cards.length).to eq(108)
    end

    it "randomizes the cards" do
      cards_1 = Deck.new.cards.map(&:card_name)
      cards_2 = Deck.new.cards.map(&:card_name)

      expect(cards_1).not_to eq(cards_2)
    end
  end
end
