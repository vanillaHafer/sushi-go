class Deck
  attr_accessor :cards

  CARD_COUNT = {
    wasabi: 6,
    egg_nigiri: 5,
    salmon_nigiri: 10,
    squid_nigiri: 5,
    tempura: 14,
    sashimi: 14,
    dumpling: 14,
    maki_1: 6,
    maki_2: 12,
    maki_3: 8,
    pudding: 10,
    chopsticks: 4
  }

  HAND_SIZE = {
    2 => 10,
    3 => 9,
    4 => 8,
    5 => 7
  }

  def initialize
    self.cards = []

    CARD_COUNT[:wasabi].times {self.cards << Card.new(card_name: "Wasabi")}
    CARD_COUNT[:egg_nigiri].times {self.cards << Card.new(card_name: "Egg Nigiri", value: 1)}
    CARD_COUNT[:salmon_nigiri].times {self.cards << Card.new(card_name: "Salmon Nigiri", value: 2)}
    CARD_COUNT[:squid_nigiri].times {self.cards << Card.new(card_name: "Squid Nigiri", value: 3)}
    CARD_COUNT[:tempura].times {self.cards << Card.new(card_name: "Tempura")}
    CARD_COUNT[:sashimi].times {self.cards << Card.new(card_name: "Sashimi")}
    CARD_COUNT[:dumpling].times {self.cards << Card.new(card_name: "Dumpling")}
    CARD_COUNT[:maki_1].times {self.cards << Card.new(card_name: "Maki(*)", maki_value: 1)}
    CARD_COUNT[:maki_2].times {self.cards << Card.new(card_name: "Maki(**)", maki_value: 2)}
    CARD_COUNT[:maki_3].times {self.cards << Card.new(card_name: "Maki(***)", maki_value: 3)}
    CARD_COUNT[:pudding].times {self.cards << Card.new(card_name: "Pudding")}
    CARD_COUNT[:chopsticks].times {self.cards << Card.new(card_name: "Chopsticks")}

    self.cards.shuffle!
  end

  def deal_cards(players)
    HAND_SIZE[players.size].times do
      players.each do |player|
        player.hand << cards.pop
      end
    end
  end
end