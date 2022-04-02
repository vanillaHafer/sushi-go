class Card
  attr_reader :value, :card_name, :maki_value
  alias_method :name, :card_name

  def initialize(card_name:, value: 0, maki_value: 0)
    @value = value
    @card_name = card_name
    @maki_value = maki_value

    if maki_value > 0 && maki?
      @card_name += " (#{"*" * maki_value})"
    end
  end

  %w[Maki Pudding].each do |n|
    define_method(:"#{n.downcase}?") do
      name.start_with?(n)
    end
  end
end
