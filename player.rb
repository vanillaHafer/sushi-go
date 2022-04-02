class Player
  attr_accessor :plate, :hand, :puddings, :maki_points, :pudding_score, :maki_rolls

  TEMPURA_POINTS = 5
  SASHIMI_POINTS = 10
  TEMPURA_NEEDED = 2
  SASHIMI_NEEDED = 3
  FIRST_PLACE_MAKI_POINTS = 6
  SECOND_PLACE_MAKI_POINTS = 3

  DUMPLING_CHART = {
    0 => 0,
    1 => 1,
    2 => 3,
    3 => 6,
    4 => 10,
    5 => 15
  }

  def initialize
    self.plate = [[],[],[]]
    self.hand  = []
    self.puddings = 0
    self.pudding_score = 0
    self.maki_points = []
    self.maki_rolls = []
  end

  def plate_value(plate_number)
    value = 0
    tempura_count = 0
    sashimi_count = 0
    dumpling_count = 0
    wasabi_count = 0

    plate[plate_number].each do |card|
      if card.nigiri?
        if wasabi_count > 0
          value += card.value * 3
          wasabi_count -= 1
        else
          value += card.value
        end
      elsif card.tempura?
        tempura_count += 1
      elsif card.sashimi?
        sashimi_count += 1
      elsif card.dumpling?
        dumpling_count += 1
      elsif card.wasabi?
        wasabi_count += 1
      end
    end

    value += maki_points[plate_number] unless maki_points[plate_number].nil?

    value += TEMPURA_POINTS * (tempura_count / TEMPURA_NEEDED)
    value += SASHIMI_POINTS * (sashimi_count / SASHIMI_NEEDED)

    dumpling_count = [5, dumpling_count].min
    value += DUMPLING_CHART[dumpling_count]
  end

  def total_value_of_all_plates
    plate.each_index.sum do |index|
      plate_value(index)
    end
  end

  def current_hand
    hand.map(&:name)
  end

  def self.update_players(players, current_round)
    round_idx = current_round - 1
    players.size.times do |player_number|
      players[player_number].maki_rolls[round_idx] = 0
      players[player_number].plate[round_idx].each do |card|
        if card.maki?
          players[player_number].maki_rolls[round_idx] += card.maki_value
        end

        players[player_number].puddings += 1 if card.pudding?
      end
    end
  end

  def self.update_maki_points(players)
    players[0].plate.size.times do |plate|
      first_place_indices = []
      first_place_amount = 0
      second_place_indices = []
      second_place_amount = 0
      
      # Check for first place players
      players.size.times do |player_number|
        if(players[player_number].maki_rolls[plate] >= first_place_amount && players[player_number].maki_rolls[plate] != 0)
          if(players[player_number].maki_rolls[plate] == first_place_amount) 
            first_place_indices << player_number
          else
            first_place_indices = [player_number]
          end
          first_place_amount = players[player_number].maki_rolls[plate]
        end
      end
      # Check for second place players
      if(first_place_indices.size == 1)
        players.size.times do |player_number| 
          if(players[player_number].maki_rolls[plate] >= second_place_amount && !first_place_indices.include?(player_number) && players[player_number].maki_rolls[plate] != 0)
            if(players[player_number].maki_rolls[plate] == second_place_amount) 
              second_place_indices << player_number
            else
              second_place_indices = [player_number]
            end
            second_place_amount = players[player_number].maki_rolls[plate]
          end
        end
      end
      
      # Award points for first place winners
      first_place_indices.each do |index|
        players[index].maki_points[plate] = FIRST_PLACE_MAKI_POINTS / first_place_indices.size
      end
      
      # Award points for second place winners (Award 1 point minimum in the case of a 4+ way tie)
      second_place_indices.each do |index|
        players[index].maki_points[plate] = SECOND_PLACE_MAKI_POINTS / second_place_indices.size > 1 ? SECOND_PLACE_MAKI_POINTS / second_place_indices.size : 1
      end
    end
  end

  def self.rotate_hands(players, clockwise = true)
    last_player_index = players.size - 1

    if clockwise
      temp_hand = players[last_player_index].hand
      players.size.times do |player_number|
        if player_number != last_player_index
          players[last_player_index - player_number].hand = players[(last_player_index - 1) - player_number].hand
        else
          players[0].hand = temp_hand
        end
      end
    else
      temp_hand = players[0].hand
      players.size.times do |player_number|
        if player_number != last_player_index
          players[player_number].hand = players[player_number + 1].hand
        else
          players[last_player_index].hand = temp_hand
        end
      end
    end
  end
end