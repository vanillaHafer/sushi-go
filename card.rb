class Card
  attr_reader :value, :card_name, :maki_value
  alias_method :name, :card_name

  def initialize(card_name:, value: 0, maki_value: 0)
    @card_name = card_name
    @value = value
    @maki_value = maki_value
  end
end
