class Console
  class << self
    WIDTH = 22

    def clear_screen
      puts "\n" * 50
    end

    def end_of_game_recap(players)
      clear_screen
      puts "*".light_white * WIDTH
      puts "* THANKS FOR PLAYING *".light_white
      puts "*".light_white * WIDTH

      Player.update_maki_points(players)
      print_plates(players)
      print_plate_scores(players)
    end

    def print_plate_scores(players)
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

    def print_plates(players)
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

    def welcome_message
      clear_screen
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