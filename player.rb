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
    self.plate = []
    self.hand  = []
    self.puddings = 0
    self.pudding_score = 0
    self.maki_points = 0
    self.maki_rolls = 0
  end

  def plate_value
    value = 0
    tempura_count   = 0
    sashimi_count   = 0
    dumpling_count  = 0
    wasabi_count    = 0
    maki_roll_count = 0

    plate.each do |card|
      if card.name.include?("Nigiri")
        if wasabi_count > 0
          value += card.value * 3
          wasabi_count -= 1
        else
          value += card.value
        end
      elsif card.name == "Tempura"
        tempura_count += 1
      elsif card.name == "Sashimi"
        sashimi_count += 1
      elsif card.name == "Dumpling"
        dumpling_count += 1
      elsif card.name == "Wasabi"
        wasabi_count += 1
      elsif card.name.include?("Maki")
        maki_roll_count += 1
      end

    end
    
    value += TEMPURA_POINTS  * (tempura_count / TEMPURA_NEEDED)
    value += SASHIMI_POINTS * (sashimi_count / SASHIMI_NEEDED)
    value += maki_points

    dumpling_count = 5 if dumpling_count > 5

    value += DUMPLING_CHART[dumpling_count]

    value
  end

  def current_plate
    plate.map(&:name)
  end

  def current_hand
    hand.map(&:name)
  end

  def self.end_of_game_recap(players)
    Console.clear_screen
    puts "*".light_white * 22
    puts "* THANKS FOR PLAYING *".light_white
    puts "*".light_white * 22

    update_maki_points(players)
    print_plates(players)
    print_plate_scores(players)
  end

  def self.update_players(players)
    players.size.times do |player_number|
      players[player_number].maki_rolls = 0
      players[player_number].puddings = 0
      players[player_number].plate.each do |item| 
        players[player_number].maki_rolls += 1 if item.card_name.include?("Maki(*)")
        players[player_number].maki_rolls += 2 if item.card_name.include?("Maki(**)")
        players[player_number].maki_rolls += 3 if item.card_name.include?("Maki(***)")
        players[player_number].puddings += 1 if item.card_name.include?("Pudding")
      end
    end
  end

  def self.update_maki_points(players)
    first_place_indices = []
    first_place_amount = 0
    second_place_indices = []
    second_place_amount = 0
    # Check for first place players
    players.size.times do |player_number|
      if(players[player_number].maki_rolls >= first_place_amount && players[player_number].maki_rolls != 0)
        if(players[player_number].maki_rolls == first_place_amount) 
          first_place_indices << player_number
        else
          first_place_indices = [player_number]
        end
        first_place_amount = players[player_number].maki_rolls
      end
    end
    # Check for second place players
    if(first_place_indices.size == 1)
      players.size.times do |player_number| 
        if(players[player_number].maki_rolls >= second_place_amount && !first_place_indices.include?(player_number) && players[player_number].maki_rolls != 0)
          if(players[player_number].maki_rolls == second_place_amount) 
            second_place_indices << player_number
          else
            second_place_indices = [player_number]
          end
          second_place_amount = players[player_number].maki_rolls 
        end
      end
    end

    # Award points for first place winners
    first_place_indices.each do |index|
      players[index].maki_points = FIRST_PLACE_MAKI_POINTS / first_place_indices.size
    end

    # Award points for second place winners (Award 1 point minimum in the case of a 4+ way tie)
    second_place_indices.each do |index|
      players[index].maki_points = SECOND_PLACE_MAKI_POINTS / second_place_indices.size > 1 ? SECOND_PLACE_MAKI_POINTS / second_place_indices.size : 1
    end
  end

  def print_plate_message(player_number)
    puts "\n*************".yellow
    puts "* Player #{player_number}: *".yellow
    puts "*************".yellow
    puts current_plate
    puts "\nIs equal to: #{plate_value}\n\n".green
  end

  def self.print_plate_scores(players)
    players.size.times do |player_number|
      print "Maki Rolls: #{players[player_number].maki_rolls}".ljust(15).magenta
    end
    puts ""
    players.size.times do |player_number|
      print "Maki: +#{players[player_number].maki_points}".ljust(15).red
    end
    puts ""
    players.size.times do |player_number|
      print "Pudding: +#{players[player_number].pudding_score}".ljust(15).blue
    end
    puts ""
    players.size.times do |player_number|
      print "Score: #{players[player_number].plate_value}".ljust(15).green
    end
    puts "\n\n"
  end

  def self.print_plates(players)
    puts "\n*****************".red
    puts "* Player Plates *".red
    puts "*****************\n".red

    # Player Nametags
    players.size.times do |player_number|
      print "************   ".yellow
    end
    print "\n"
    # require 'pry'; binding.pry;
    players.size.times do |player_number|
      print "*   (#{players[player_number].puddings})    *   ".yellow
    end
    print "\n"
    players.size.times do |player_number|
      print "* Player #{player_number + 1} *   ".yellow
    end
    print "\n"
    players.size.times do |player_number|
      print "************   ".yellow
    end
    print "\n"

    # Player player contents
    players[0].plate.size.times do |plate_item|
      players.size.times do |player_number|
        print "#{players[player_number].plate[plate_item].name}".ljust(15, ' ').cyan
      end
      print "\n"
    end
    print "\n"
  end

  def print_my_hand
    puts "\n****************".red
    puts "* Current Hand *".red
    puts "****************".red
    card_number = 1
    current_hand.each do |card|
      puts "[#{card_number}]".green + card
      card_number += 1
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