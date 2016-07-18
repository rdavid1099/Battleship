require './lib/player'

class ComputerOpponent < Player
  attr_reader   :ships,
                :all_ship_placements
                
  attr_accessor :current_ship,
                :game_board

  def initialize(game_board = GameBoard.new)
    @game_board = game_board
    @ships = Array.new
    @all_ship_placements = Array.new
  end

  def generate_strike
    [rand(game_board.size - 1), rand(game_board.size - 1)]
  end

  def computers_turn
    loop do
      strike = generate_strike
      return strike if game_board.valid_shot?(strike[0], strike[1])
    end
  end

  def add_ship(ship)
    @ships << ship
  end

  def generate_ship_locations
    @ships.each do |ship|
      @current_ship = ship
      ship_coordinates = [get_first_placement]
      remaining_coordinates = get_next_placement(ship_coordinates[0])
      remaining_coordinates.each { |coordinate| ship_coordinates << coordinate }
      update_all_ship_placements(ship_coordinates)
      ship.place_on_game_board(ship_coordinates)
    end
  end

  def get_first_placement
    loop do
      placement_coordinates = [rand(game_board.size - 1), rand(game_board.size - 1)]
      return placement_coordinates if coordinates_clear?(placement_coordinates) && surroundings_are_clear(placement_coordinates)
    end
  end

  def get_next_placement(prev_placement)
    next_placement_options = generate_next_valid_coordinates_for_ship_placement(prev_placement)
    return computer_chooses_ship_placement(next_placement_options)
  end

  def computer_chooses_ship_placement(available_coordinates)
    loop do
      computer_choice = rand(3)
      return available_coordinates[computer_choice] if computer_choice < available_coordinates.length
    end
  end
end
