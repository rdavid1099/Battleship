require './lib/game_board'
require './lib/player'
require './lib/computer_opponent'

class GameManager
  attr_reader :game_board,
              :player,
              :computer_opponent

  def initialize
    @player = Player.new('TESTING')
    # @player = create_new_player
    @game_board = GameBoard.new
    # @game_board = create_game_board
    @computer_opponent = ComputerOpponent.new
    # start_round
  end

  def create_new_player
    Player.new(get_player_name)
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
    return GameBoard.new(4) if difficulty == 1
    return GameBoard.new(8) if difficulty == 2
    return GameBoard.new(12) if difficulty == 3
  end

  def user_chooses_difficulty
    print "Thank you, #{player.name}.\nPlease select the level of difficulty.\n1. Beginner (4x4 map)\n2. Intermediate (8x8 map)\n3. Advanced (12x12 map)\n> "
    difficulty = gets.chomp.to_i
    return difficulty unless difficulty == 0 || difficulty > 3
    puts "You must select one of the difficuly levels."
    user_chooses_difficulty
  end

  def yes_or_no_confirmed?(answer)
    return true if answer == 'y' || answer == 'n'
    # puts "You must enter either Y or N."
    return false
  end

  def start_round
    puts title_screen

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
