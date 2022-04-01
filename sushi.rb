require_relative 'card.rb'
require_relative 'console.rb'
require_relative 'deck.rb'
require_relative 'player.rb'

require 'colorize'

CLOCKWISE = true
COUNTER_CLOCKWISE = false

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

# Deal cards to the players
deck.deal_cards(players)

# Main loop
while(!game_over)
  # Clear the screen of any previous turn garbage
  Console.clear_screen

  # Print a display of players current plates
  Player.print_plates(players)

  # Print a display of the users hand
  players[0].print_my_hand

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
  players[0].plate << players[0].hand.delete_at(card_to_play - 1)

  # Have the computers select a random card to play
  players.size.times do |player_number|
    next if player_number == 0
    num_of_cards = players[player_number].hand.size
    players[player_number].plate << players[player_number].hand.delete_at(rand(0..num_of_cards - 1))
  end
    
  # Trade hands with all the players
  Player.rotate_hands(players, COUNTER_CLOCKWISE)

  # Update players
  Player.update_players(players)

  # [TEMP] End the game once the play runs out of cards. (This will just be the end of the round)
  game_over = true if(players[0].hand.size <= 0)
end

Player.end_of_game_recap(players)
