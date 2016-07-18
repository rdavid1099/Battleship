require './lib/game_board'
require './lib/player'
require './lib/computer_opponent'
require './lib/ship'

class GameManager
  attr_reader :game_board,
              :player,
              :computer_opponent,
              :difficulty

  def initialize
    @difficulty = 1
  end

  def launch
    @player = Player.new('TESTING')
    # @player = Player.new(get_player_name)
    # board_size = create_game_board
    board_size = 4
    @game_board = GameBoard.new(board_size)
    @player.game_board = GameBoard.new(board_size)
    @computer_opponent = ComputerOpponent.new(GameBoard.new(board_size))
    # puts title_screen
    # start_round
  end

  def get_player_name
    # print "Welcome to BATTLESHIP.\nBefore we begin, please enter your name.\n> "
    # name = gets.chomp
    name = 'TESTING'
    confirm_player_name(name)
  end

  def confirm_player_name(name)
    # print "You entered: #{name}. Is that correct (Y/N)?\n> "
    # answer = gets.chomp.downcase
    answer = 'y'
    if yes_or_no_confirmed?(answer)
      answer == 'y' ? name : get_player_name
    else
      confirm_player_name(name)
    end
  end

  def create_game_board
    difficulty = user_chooses_difficulty
    difficulty * 4
  end

  def user_chooses_difficulty
    print "Thank you, #{player.name}.\nPlease select the level of difficulty.\n1. Beginner (4x4 map)\n2. Intermediate (8x8 map)\n3. Advanced (12x12 map)\n> "
    difficulty = gets.chomp.to_i
    return difficulty unless difficulty <= 0 || difficulty > 3
    puts "You must select one of the difficuly levels."
    user_chooses_difficulty
  end

  def start_game
    menu_selection = welcome_menu
    setup_round if menu_selection[0] == 'p'
    instructions if menu_selection[0] == 'i'
    exit_game if menu_selection[0] == 'q'
  end

  def welcome_menu
    loop do
      # print "Welcome to BATTLESHIP\n\nWould you like to (p)lay, read the (i)nstructions, or (q)uit?\n> "
      # user_input = gets.chomp.downcase
      user_input = "p"
      return user_input if valid_welcome_input(user_input)
      puts "Your selection is not valid."
    end
  end

  def setup_round
    puts "LET'S PLAY BATTLESHIP!"
    build_ships
    player.place_ship_on_board
    computer_opponent.generate_ship_locations
    play_game
  end

  def play_game


  end

  def end_game

  end

  def exit_game
    puts "Thank you for playing BATTLESHIP!"
    exit
  end

  def valid_welcome_input(user_input)
    if user_input.length == 1
      return true if user_input == 'p' || user_input == 'i' || user_input == 'q'
    else
      return true if user_input == 'play' || user_input == 'instructions' || user_input == 'quit'
    end
  end

  def yes_or_no_confirmed?(answer)
    return true if answer == 'y' || answer == 'n'
    # puts "You must enter either Y or N."
    return false
  end

  def build_ships
    counter = 1 + @difficulty
    counter.times do
      ship = Ship.new(counter)
      player.add_ship(ship)
      computer_opponent.add_ship(ship)
      counter += 1
    end
  end

  def instructions
    puts "Battleship (or Battleships) is a game for two players where you
    try to guess the location of ships your opponent has hidden
    on a grid. Players take turns calling out a row and column,
    attempting to name a square containing enemy ships. Originally
    published as Broadsides by Milton Bradley in 1931,
    the game was eventually reprinted as Battleship.
    PRESS ENTER TO CONTINUE"
    gets.chomp
    start_game
  end

  def title_screen
    '______  ___ _____ _____ _     _____ _____ _   _ ___________
  | ___ \/ _ |_   _|_   _| |   |  ___/  ___| | | |_   _| ___ \
  | |_/ / /_\ \| |   | | | |   | |__ \ `--.| |_| | | | | |_/ /
  | ___ |  _  || |   | | | |   |  __| `--. |  _  | | | |  __/
  | |_/ | | | || |   | | | |___| |___/\__/ | | | |_| |_| |
  \____/\_| |_/\_/   \_/ \_____\____/\____/\_| |_/\___/\_|'
  end
end
