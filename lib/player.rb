require './lib/ship'
class Player
  attr_reader   :name,
                :ships
  attr_accessor :game_board

  def initialize(name)
    @name = name
    @ships = Array.new
    @ships = [Ship.new]
    @all_ship_placements = Array.new
  end

  def place_ship_on_board(ship)
    @ships << ship
    ship_coordinates = [get_first_placement]
    (ship.size - 1).times { ship_coordinates << get_next_placement(placement[-1]) }
    ship.placement(ship_coordinates)
  end

  def get_next_placement(prev_placement)
    next_placement_options = generate_next_valid_coordinates_for_ship_placement(prev_placement)
    
  end

  def generate_next_valid_coordinates_for_ship_placement(anchor_point)
    all_possible_placements = Array.new
    all_possible_placements << @placements if all_clear(anchor_point, "up")
    all_possible_placements << @placements if all_clear(anchor_point, "down")
    all_possible_placements << @placements if all_clear(anchor_point, "left")
    all_possible_placements << @placements if all_clear(anchor_point, "right")
    return all_possible_placements
  end

  def all_clear(anchor_point, direction)
    x_coordinate = anchor_point[0]
    y_cooridnate = anchor_point[1]
    @placements = []
    (@ships[-1].size - 1).times { @placements << [(x_coordinate -= 1), y_cooridnate] } if direction == "up"
    (@ships[-1].size - 1).times { @placements << [(x_coordinate += 1), y_cooridnate] } if direction == "down"
    (@ships[-1].size - 1).times { @placements << [x_coordinate, (y_cooridnate -= 1)] } if direction == "left"
    (@ships[-1].size - 1).times { @placements << [x_coordinate, (y_cooridnate += 1)] } if direction == "right"
    @placements.all? { |coordinate| coordinates_clear?(coordinate) && game_board.shot_out_of_bounds?(coordinate[0],coordinate[1]) == false }
  end

  def get_first_placement
    loop do
      print "Enter the coordinates of where you would like to place this #{ships[-1].size} unit ship.\n> "
      placement_coodinates = input
      if coordinates_clear?(placement_coodinates)
        return placement_coodinates
      else
        puts "One of your ships is already occupying that spot."
      end
    end
  end

  def coordinates_clear?(coodinates)
    return true if @all_ship_placements.empty?
    @all_ship_placements.none? { |prev_coordinate| prev_coordinate == coodinates}
  end

  def input_strike
    print "What are the coordinates of your strike?\n> "
    input
  end

  def input
    player_input = String.new
    loop do
      @coordinates_valid = true
      # player_input = gets.chomp.downcase
      player_input = "a,0"
      player_input = format_input(player_input)
      break if game_board.valid_shot?(player_input[0],player_input[1])
      error_message(player_input)
    end
    player_input
  end

  def format_input(player_input)
    player_coordinates = converted_input(player_input.chars)
    return [99,99] if player_coordinates == nil
    player_coordinates.map do |char|
      char = char.ord - 97 if char =~ /[a-z]/
      char.to_i
    end
  end

  def converted_input(input)
    formatted_input = split(input)
    return coordinates_not_valid unless valid_coordinates?(formatted_input)
    formatted_input.reverse! if formatted_input[0] =~ /[0-9]/
    formatted_input
  end

  def split(input)
    split_chars = input.map { |char| char if char =~ /[a-z0-9]/ }.compact
    return split_chars unless split_chars.length != 2
    return split_chars.push("Z") if split_chars.length == 1
    combine_split_numbers(split_chars)
  end

  def combine_split_numbers(input)
    complete_numbers = String.new
    input.each { |char| complete_numbers += char unless char =~ /[a-z]/ }
    input.reverse! if input[0] =~ /[0-9]/
    [input[0], complete_numbers]
  end

  def valid_coordinates?(input)
    !input.all? { |char| char =~ /[a-z]/ }
  end

  def coordinates_not_valid
    @coordinates_valid = false
    puts "You must enter valid coordinates i.e.: 'A,0'."
  end

  def error_message(bad_coordinates)
    if game_board.shot_out_of_bounds?(bad_coordinates[0],bad_coordinates[1]) && @coordinates_valid
      puts "You must enter valid coordinates within the #{game_board.size}x#{game_board.size} game board."
    elsif @coordinates_valid == false
      return nil
    else
      puts game_board.mark_shot(bad_coordinates[0],bad_coordinates[1])
    end
  end

end
