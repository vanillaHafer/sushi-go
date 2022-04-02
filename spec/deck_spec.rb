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

  describe "#deal_cards" do
    let(:deck) { described_class.new }
    let(:players) {
      [Player.new, Player.new]
    }

    context "empty cards" do
      described_class::HAND_SIZE.each do |k, v|
        context "when there are #{k} players" do
          it "reduces the deck by #{k * v}" do
            expect {
              deck.deal_cards(k.times.map { Player.new })
            }.to change {
              deck.cards.length
            }.by(
              -(k * v)
            )
          end

          it "adds #{v} cards to each player's hand" do
            players = k.times.map { Player.new }
            deck.deal_cards(players)
            expect(players.all? { |p| p.hand.length == v }).to eq(true)
          end
        end
      end
    end
  end
end
