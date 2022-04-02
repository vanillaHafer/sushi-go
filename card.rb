require "./deck"

class Card
  attr_reader :value, :card_name, :maki_value
  alias_method :name, :card_name

  Deck::CARD_COUNT.keys.each do |n|
    method_name = n.to_s.gsub(/_\d/, "")
    define_method(:"#{method_name}?") do
      name.downcase.tr(" ", "_").start_with?(method_name)
    end
  end

  def nigiri?
    name.downcase.include?("nigiri")
  end

  def initialize(card_name:, value: 0, maki_value: 0)
    @value = value
    @card_name = card_name
    @maki_value = maki_value

    if maki_value > 0 && maki?
      @card_name += " (#{"*" * maki_value})"
    end
  end
end
