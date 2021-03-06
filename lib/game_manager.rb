require './lib/game_board'
require './lib/player'
require './lib/computer_opponent'
require './lib/ship'
require 'colorize'

class GameManager
  attr_reader :game_board,
              :player,
              :computer_opponent,
              :difficulty

  def initialize
    @difficulty = 1
  end

  def launch
    puts "\e[H\e[2J"
    # @player = Player.new('TESTING')
    @player = Player.new(get_player_name)
    board_size = create_game_board
    # board_size = 4
    @game_board = GameBoard.new(board_size)
    @player.game_board = GameBoard.new(board_size)
    @player.opponent_game_board = @game_board
    @computer_opponent = ComputerOpponent.new(GameBoard.new(board_size))
    puts title_screen
    start_game
  end

  def get_player_name
    print "Welcome to #{"BATTLESHIP".red}.\nBefore we begin, please enter your name.\n> "
    name = gets.chomp
  end

  def create_game_board
    @difficulty = user_chooses_difficulty
    @difficulty * 4
  end

  def user_chooses_difficulty
    loop do
      print "Thank you, #{player.name}.\nPlease select the level of difficulty.\n1. #{"Beginner (4x4 map)".green}\n2. #{"Intermediate (8x8 map)".yellow}\n3. #{"Advanced (12x12 map)".red}\n> "
      difficulty = gets.chomp.to_i
      return difficulty unless difficulty <= 0 || difficulty > 3
      puts "You must select one of the difficuly levels."
    end
  end

  def start_game
    menu_selection = welcome_menu
    setup_round if menu_selection[0] == 'p'
    instructions if menu_selection[0] == 'i'
    exit_game if menu_selection[0] == 'q'
  end

  def welcome_menu
    puts "\e[H\e[2J"
    loop do
      print "Welcome to #{"BATTLESHIP".red}\n\nWould you like to (p)lay, read the (i)nstructions, or (q)uit?\n> "
      user_input = gets.chomp.downcase
      # user_input = "p"
      return user_input if valid_welcome_input(user_input)
      puts "Your selection is not valid."
    end
  end

  def setup_round
    puts "\e[H\e[2J"
    clear_game_board
    @timer_start = Time.new
    puts "LET'S PLAY BATTLESHIP!"
    build_ships
    player.place_ship_on_board
    computer_opponent.generate_ship_locations
    if ship_placement_confirmed == 'y'
      play_game
    else
      setup_round
    end
  end

  def ship_placement_confirmed
    puts "\e[H\e[2J"
    puts "Here is where you have placed your ships."
    puts player.game_board.generate_current_display
    print "Are you satisfied with your placements (Y/N)?\n> "
    user_satisfied = gets.chomp.downcase
    user_satisfied if yes_or_no_confirmed?(user_satisfied)
  end

  def play_game
    print_mission_op
    puts "\e[H\e[2J"
    loop do
      main_game_display
      player_choice = in_game_options_menu_display
      get_player_next_move(player_choice)
      if player_choice == 'a'
        break if boats_sunk?('computer')
        computer_launch_attack
        break if boats_sunk?('player')
      end
    end
    boats_sunk?('computer') ? end_game('win') : end_game('lose')
  end

  def computer_launch_attack
    register_attack_coordinates(computer_opponent.computers_turn, 'computer')
  end

  def user_launch_attack
    print "Launch your attack!\nEnter the coordinates you would like to shoot.\n> "
    register_attack_coordinates(player.input, 'player')
    puts "\e[H\e[2J"
  end

  def register_attack_coordinates(player_input, player_or_computer)
    if shot_hits_a_ship?(player_input, player_or_computer)
      record_damage(player_input, player_or_computer)
    else
      game_board.mark_shot(player_input[0],player_input[1]) if player_or_computer == 'player'
      player.game_board.mark_shot(player_input[0],player_input[1]) if player_or_computer == 'computer'
    end
  end

  def record_damage(player_input, player_or_computer)
    if player_or_computer == 'player'
      game_board.mark_hit(player_input[0],player_input[1])
      computer_opponent.ship_damaged(player_input)
    else
      player.game_board.mark_hit(player_input[0],player_input[1])
      player.ship_damaged(player_input)
    end
  end

  def shot_hits_a_ship?(player_input, player_or_computer)
    if player_or_computer == 'player'
      computer_opponent.all_ship_placements.any? {|coordinate| coordinate == player_input}
    else
      player.all_ship_placements.any? {|coordinate| coordinate == player_input}
    end
  end

  def boats_sunk?(player_or_computer)
    if player_or_computer == 'computer'
      computer_opponent.ships.all? { |boat| boat.under_the_sea? }
    else
      player.ships.all? { |boat| boat.under_the_sea? }
    end
  end

  def end_game(outcome)
    puts "\e[H\e[2J"
    if outcome == 'win'
      puts "CONGRATULATIONS #{player.name.upcase}!".yellow + " Your enemies tremble at the thought of your unstoppable fleet."
      game_stats
    elsif outcome == 'lose'
      puts "Broken, beaten, and scarred, your enemy leaves you defeated.\nYour enemy may have won the battle, but the war is far from over."
      game_stats
    end
    exit_game unless play_another_game?
    start_game
  end

  def play_another_game?
    print "Would you like to play another game (Y/N)?\n> "
    answer = gets.chomp.downcase
    if yes_or_no_confirmed?(answer) && answer == 'y'
      true
    else
      false
    end
  end

  def exit_game
    puts "Thank you for playing BATTLESHIP!"
    abort
  end

  def main_game_display
    puts "#{game_board.generate_border}CURRENT  RADAR".center((game_board.size * 3) + 2)
    puts game_board.generate_current_display
    puts "#{player.name.upcase}'S FLEET".center((game_board.size * 3) + 2)
    puts player.game_board.generate_current_display
  end

  def display_player_fleet_status
    puts "\e[H\e[2J"
    puts "STATUS OF #{player.name.upcase}'S FLEET".center(59)
    player.ships.each { |ship| puts ship.status }
  end

  def game_stats
    puts "\e[H\e[2J"
    @timer_now = Time.new
    total_time = ((@timer_now - @timer_start) / 60).round
    total_shots = game_board.total_number_of_shots
    total_hits = game_board.total_number_of_hits
    total_misses = game_board.total_number_of_shots - game_board.total_number_of_hits
    puts "GAME STATS\n===================="
    puts "Total shots fired: #{total_shots}"
    puts "Shots Landed: #{total_hits}"
    puts "Shots Missed: #{total_misses}"
    puts "Percentage Hit: #{((total_hits / total_shots.to_f) * 100).round}%" if total_shots > 0
    puts "Total Playtime: #{total_time} minutes"
  end

  def downed_enemy_ships_stats
    puts "\e[H\e[2J"
    puts "FALLEN ENEMY SHIPS!".center(59)
    computer_opponent.display_downed_ships
  end

  def in_game_options_menu_display
    print "Enter your next move or (Q)uit:\nDisplay (F)leet Status, Display Enemy's (D)owned Ships\nGame (S)tats, Fire (A)ttack\n> "
    validate_menu_input(gets.chomp.downcase)
  end

  def validate_menu_input(user_choice)
    return user_choice[0] if user_choice[0] =~ /[adfsq]/
    puts "You must enter a valid option."
    in_game_options_menu_display
  end

  def get_player_next_move(user_choice)
    user_launch_attack if user_choice == 'a'
    downed_enemy_ships_stats if user_choice == 'd'
    display_player_fleet_status if user_choice == 'f'
    game_stats if user_choice == 's'
    end_game("quit") if user_choice == 'q'
  end

  def clear_game_board
    @timer_start = nil
    player.reset
    computer_opponent.reset
  end

  def valid_welcome_input(user_input)
    if user_input.length == 1
      return true if user_input =~ /[piq]/
    else
      return true if user_input == 'play' || user_input == 'instructions' || user_input == 'quit'
    end
  end

  def yes_or_no_confirmed?(answer)
    loop do
      return true if answer == 'y' || answer == 'n'
      print "You must enter either Y or N.\n> "
      answer = gets.chomp.downcase
    end
  end

  def build_ships
    counter = 1 + @difficulty
    ship_size = 2
    counter.times do
      player.add_ship(Ship.new(ship_size))
      computer_opponent.add_ship(Ship.new(ship_size))
      ship_size += 1
    end
  end

  def print_mission_op
    puts "\e[H\e[2J"
    mission1 = "ATTENTION ADMIRAL...INTEL TELLS US AN ENEMY FLEET HAS US IN THEIR SIGHTS..."
    mission2 = "...YOUR MISSION IS TO DESTROY ALL ENEMY SHIPS...BEFORE YOUR FLEET IS DESTROYED..."
    mission3 = "...IT'S A DOG EAT DOG WORLD OUT THERE...AND YOU'RE OUR ONLY HOPE."
    mission1.chars.each do |letter|
      print letter
      sleep(0.15)
    end
    print "\n"
    mission2.chars.each do |letter|
      print letter
      sleep(0.15)
    end
    print "\n"
    mission3.chars.each do |letter|
      print letter
      sleep(0.15)
    end
    sleep(2)
    print "\n"
  end

  def instructions
    puts "\e[H\e[2J"
    puts "Battleship (or Battleships) is a game for two players where you \ntry to guess the location of ships your opponent has hidden \non a grid. Players take turns calling out a row and column, \nattempting to name a square containing enemy ships. Originally \npublished as Broadsides by Milton Bradley in 1931, \nthe game was eventually reprinted as Battleship.\n\nPRESS ENTER TO CONTINUE"
    gets.chomp
    start_game
  end

  def title_screen
    puts "\e[H\e[2J"
    '  ______  ___ _____ _____ _     _____ _____ _   _ ___________
  | ___ \/ _ |_   _|_   _| |   |  ___/  ___| | | |_   _| ___ \
  | |_/ / /_\ \| |   | | | |   | |__ \ `--.| |_| | | | | |_/ /
  | ___ |  _  || |   | | | |   |  __| `--. |  _  | | | |  __/
  | |_/ | | | || |   | | | |___| |___/\__/ | | | |_| |_| |
  \____/\_| |_/\_/   \_/ \_____\____/\____/\_| |_/\___/\_|'
  end
end
