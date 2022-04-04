FactoryBot.define do
  to_create { nil }

  factory :player do
    [1, 2, 3].each do |i|

      trait :"maki_#{i}" do
        maki_rolls { [i, 0, 0] }
      end

      trait :"chopsticks_1" do
        plate { [[Card.new(card_name: "Chopsticks")], [], []]}
      end

      trait :"chopsticks_2" do
        plate { [[Card.new(card_name: "Chopsticks"), Card.new(card_name: "Chopsticks")], [], []]}
      end
    end
  end
end
