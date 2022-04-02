require "io/console"

class Console
  class << self
    WIDTH = 22

    def end_of_game_recap(players)
      IO.console.clear_screen
      puts "*".light_white * WIDTH
      puts "* THANKS FOR PLAYING *".light_white
      puts "*".light_white * WIDTH

      Player.update_maki_points(players)
      Player.update_pudding_score(players)
      print_plates_from_all_rounds(players)
      print_plate_scores(players)
    end

    def print_plate_scores(players)
      players.size.times do |player_number|
        print "Score: #{players[player_number].total_value_of_all_plates}".ljust(21).green
      end
      puts "\n"

      players.size.times do |player_number|
        if(players[player_number].pudding_score > 0)
          print "Pudding: #{players[player_number].pudding_score}".ljust(21).light_green
        elsif(players[player_number].pudding_score == 0)
          print "Pudding: #{players[player_number].pudding_score}".ljust(21)
        elsif(players[player_number].pudding_score < 0)
          print "Pudding: #{players[player_number].pudding_score}".ljust(21).red
        end
      end
      puts "\n"
      
      players.size.times do |player_number|
        print "FinalScore: #{players[player_number].total_value_of_all_plates + players[player_number].pudding_score}".ljust(21).green.bold
      end
      puts "\n\n"
    end

    def print_plates(players, current_round)
      puts "\n*****************".red
      puts "* Player Plates *".red
      puts "*****************\n".red

      # Player Nametags
      players.size.times do |player_number|
        print "******************   ".yellow
      end
      print "\n"
      # require 'pry'; binding.pry;
      players.size.times do |player_number|
        print "*      (#{players[player_number].puddings})       *   ".yellow
      end
      print "\n"
      players.size.times do |player_number|
        print "*    Player #{player_number + 1}    *   ".yellow
      end
      print "\n"
      players.size.times do |player_number|
        print "******************   ".yellow
      end
      print "\n"

      # Player plate contents
      players[0].plate[current_round - 1].size.times do |plate_item|
        players.size.times do |player_number|
          print "#{players[player_number].plate[current_round - 1][plate_item].name}".ljust(21).cyan
        end
        print "\n"
      end
      print "\n"
    end

    def print_plates_from_all_rounds(players)
      puts "\n*****************".red
      puts "* Player Plates *".red
      puts "*****************\n".red

      # Player Nametags
      players.size.times do |player_number|
        print "******************   ".yellow
      end
      print "\n"
      # require 'pry'; binding.pry;
      players.size.times do |player_number|
        print "*      (#{players[player_number].puddings})       *   ".yellow
      end
      print "\n"
      players.size.times do |player_number|
        print "*    Player #{player_number + 1}    *   ".yellow
      end
      print "\n"
      players.size.times do |player_number|
        print "******************   ".yellow
      end
      print "\n"

      # Player plate contents
      players[0].plate.size.times do |plate_number|
      
        players[0].plate[plate_number].size.times do |plate_item|
          
          players.size.times do |player_number|
            print "#{players[player_number].plate[plate_number][plate_item].name}".ljust(21).cyan
          end
          print "\n"
        
        end
        players.size.times do |player_number|
          print "Score: #{players[player_number].plate_value(plate_number)}".ljust(21).green
        end
        print "\n"
        print "\n"
      
      end
      print "\n"
    end

    def print_my_hand(hand)
      puts "\n****************".red
      puts "* Current Hand *".red
      puts "****************".red
      card_number = 1
      hand.each do |card|
        puts "[#{card_number}]".green + card
        card_number += 1
      end
    end

    def print_round_number(current_round)
      puts "***********".blue
      puts "* Round #{current_round} *".blue
      puts "***********".blue
    end
    
    def print_new_round
      puts "*********************".green
      puts "* NEW ROUND STARTED *".green
      puts "*********************".green
    end

    def welcome_message
      IO.console.clear_screen
      print "
      __        __   _                            _        
      \\ \\      / /__| | ___ ___  _ __ ___   ___  | |_ ___  
       \\ \\ /\\ / / _ \\ |/ __/ _ \\| '_ ` _ \\ / _ \\ | __/ _ \\ 
        \\ V  V /  __/ | (_| (_) | | | | | |  __/ | || (_) |
         \\_/\\_/ \\___|_|\\___\\___/|_| |_| |_|\\___|  \\__\\___/".green
      puts "
               ____            _     _    ____       
              / ___| _   _ ___| |__ (_)  / ___| ___  
              \\___ \\| | | / __| '_ \\| | | |  _ / _ \\ 
               ___) | |_| \\__ \\ | | | | | |_| | (_) |
              |____/ \\____|___/_| |_|_|  \\____|\\___/
              
              ".red
    end
  end
end