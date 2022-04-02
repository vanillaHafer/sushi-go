require_relative 'card.rb'
require_relative 'console.rb'
require_relative 'deck.rb'
require_relative 'player.rb'

require 'colorize'
require "io/console"

# Determines when the game is over and to exit the main loop
game_over = false

# Array of players
players = []

# Display a welcome message
Console.welcome_message

# Total players that will be given by the user
total_players = 0

class QuitGame < StandardError
  def self.quit
    IO.console.clear_screen
    rows, cols = IO.console.winsize
    message = "GAME OVER"
    puts "\n" * (rows / 2 - 1)
    print " " * ((cols - message.length) / 2)
    print message
    print " " * ((cols - message.length) / 2)
    puts "\n" * (rows / 2)
    exit(0)
  end
end
%w[SIGINT SIGQUIT].each { |s| trap(s) { QuitGame.quit } }

def get_number(quit: %w[q quit done])
  input = gets&.chomp
  raise QuitGame if input.nil? || quit.include?(input)
  input.to_i
end

# Get input of how many players are playing
while total_players < 2 || total_players > 5
  puts "How many players will be playing today?".blue
  print ">".blue
  begin
    total_players = get_number
    unless total_players > 1 && total_players < 6
      puts "Please pick a number between 2 and 5".red
    end
  rescue QuitGame
    QuitGame.quit
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
      begin
        card_to_play = get_number

        if card_to_play - 1 < 0 || card_to_play > players[0].current_hand.size
          puts "⛔️ Invalid selection ⛔️".red
        end
      rescue QuitGame
        QuitGame.quit
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
