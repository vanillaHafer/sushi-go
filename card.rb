class Card
  attr_reader :value, :card_name, :maki_value

  def initialize(card_name:, value: 0, maki_value: 0)
    @card_name = card_name
    @value = value
    @maki_value = maki_value
  end

  def name 
    if self.class.to_s.include?("Maki")
      "Maki(#{"*" * self.maki_value})"
    else
      self.card_name
    end
  end
end