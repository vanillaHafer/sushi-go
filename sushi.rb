require_relative 'card.rb'
require_relative 'console.rb'
require_relative 'deck.rb'
require_relative 'player.rb'

require 'colorize'

# Determines when the game is over and to exit the main loop
game_over = false

# Array of players
players = []

# Display a welcome message
Console.welcome_message

# Total players that will be given by the user
total_players = 0

# Get input of how many players are playing
while total_players < 2 || total_players > 5 do
  puts "How many players will be playing today?".blue
  print ">".blue
  total_players = gets.chomp.to_i
  unless total_players > 1 && total_players < 6
    puts "Please pick a number between 2 and 5".red 
  end
end

# Create a new, shuffled, deck of cards
deck = Deck.new

# Establish the players
total_players.times do |p|
  players[p] = Player.new
end

# Initialize the round counters
prev_round = 0
current_round = 1

# Initialize the card passing direction
going_clockwise = true

# Main loop
while(!game_over)
  while(current_round <= 3)

    # Clear the screen of any previous turn garbage
    Console.clear_screen

    if(current_round != prev_round)
      # Deal more cards to the players
      deck.deal_cards(players)

      # Notify of a new round beginning
      Console.print_new_round

      # Toggle the direction which hands go
      going_clockwise = !going_clockwise
    end
  

    # Print the current round number
    Console.print_round_number(current_round)
    
    # Print a display of players current plates
    Console.print_plates(players, current_round)
    
    # Print a display of the users hand
    Console.print_my_hand(players[0].current_hand)
    
    # Card the user will play from their hand
    card_to_play = 0
    
    # Get input from the user on which card they want to play
    while(card_to_play - 1 < 0 || card_to_play > players[0].current_hand.size)
      puts "\nWhich card would you like to play?".blue
      print ">".blue
      card_to_play = gets.chomp.to_i
      if card_to_play - 1 < 0 || card_to_play > players[0].current_hand.size
        puts "⛔️ Invalid selection ⛔️".red
      end
    end
    
    # Move the selected card from your hand to your plate
    players[0].plate[current_round - 1] << players[0].hand.delete_at(card_to_play - 1)
    
    # Have the computers select a random card to play
    players.size.times do |player_number|
      next if player_number == 0
      num_of_cards = players[player_number].hand.size
      players[player_number].plate[current_round - 1] << players[player_number].hand.delete_at(rand(0..num_of_cards - 1))
    end
    
    # Trade hands with all the players
    Player.rotate_hands(players, going_clockwise)

    prev_round = current_round
    if(players[0].hand.size <= 0)
      # Update players
      Player.update_players(players, current_round)
      
      current_round += 1 
    end
  end
  game_over = true 
end
Console.end_of_game_recap(players)
