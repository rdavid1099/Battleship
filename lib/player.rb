require './lib/ship'
require './lib/coordinate_manager'

class Player
  include CoordinateManager

  attr_reader   :name,
                :ships,
                :all_ship_placements

  attr_accessor :game_board,
                :opponent_game_board,
                :current_ship

  def initialize(name)
    @name = name
    @ships = Array.new
    @all_ship_placements = Array.new
  end

  def add_ship(ship)
    @ships << ship
  end

  def update_all_ship_placements(ship_coordinates)
    game_board.mark_ship_location(ship_coordinates)
    ship_coordinates.each { |coordinate| @all_ship_placements << coordinate }
  end

  def ship_damaged(coordinates)
    @ships.each do |ship|
      ship.placement.each.with_index { |placement, index| ship.shot(index) if placement == coordinates}
    end
  end

  def place_ship_on_board
    @ships.each do |ship|
      @current_ship = ship
      ship_coordinates = [get_first_placement]
      remaining_coordinates = get_next_placement(ship_coordinates[0])
      remaining_coordinates.each { |coordinate| ship_coordinates << coordinate }
      update_all_ship_placements(ship_coordinates)
      ship.place_on_game_board(ship_coordinates)
    end
  end

  def get_next_placement(prev_placement)
    next_placement_options = generate_next_valid_coordinates_for_ship_placement(prev_placement)
    return user_chooses_ship_placement(next_placement_options)
  end

  def user_chooses_ship_placement(available_coordinates)
    loop do
      print remaining_placement_menu(available_coordinates)
      user_choice = gets.chomp.to_i
      # user_choice = 2
      return available_coordinates[user_choice - 1] unless user_choice <= 0 || user_choice > available_coordinates.length
      puts "You must enter a selection between 1 and #{available_coordinates.length}."
    end
  end

  def get_first_placement
    loop do
      print "Please enter the coordinates of where you would like to place your #{current_ship.size} unit ship.\n> "
      placement_coordinates = input
      if coordinates_clear?(placement_coordinates) && surroundings_are_clear(placement_coordinates)
        return placement_coordinates
      else
        puts "One of your ships is already occupying that spot."
      end
    end
  end

  def remaining_placement_menu(placement_options)
    menu = "Please select the placement you would like for this #{current_ship.size} unit ship\n"
    placement_options.each.with_index do |coordinates, index|
      menu += "#{index + 1})#{convert_cordinate_to_text(coordinates)}\n"
    end
    menu += "> "
  end

  def convert_cordinate_to_text(coordinates)
    converted_to_text = " "
    coordinates.each do |coordinate|
      converted_to_text += " #{(coordinate[0] + 65).chr},#{(coordinate[1] + 1)} "
    end
    converted_to_text
  end

  def input
    player_input = String.new
    loop do
      @coordinates_valid = true
      player_input = gets.chomp.downcase
      # player_input = "a,1"
      player_input = format_input(player_input)
      break if opponent_game_board.valid_shot?(player_input[0],player_input[1])
      error_message(player_input)
    end
    player_input
  end

  def format_input(player_input)
    player_coordinates = converted_input(player_input.chars)
    return [99,99] if player_coordinates == nil
    player_coordinates.map do |char|
      char = char.ord - 96 if char =~ /[a-z]/
      char.to_i - 1
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
    return false if input.all? { |char| char =~ /[a-z]/ }
    return false if input.any? { |char| char =~ /0/ }
    true
  end

  def coordinates_not_valid
    @coordinates_valid = false
    print "You must enter valid coordinates i.e.: 'A,1'.\n> "
  end

  def error_message(bad_coordinates)
    if game_board.shot_out_of_bounds?(bad_coordinates[0],bad_coordinates[1]) && @coordinates_valid
      print "You must enter valid coordinates within the #{game_board.size}x#{game_board.size} game board.\n> "
    elsif @coordinates_valid == false
      return nil
    else
      print opponent_game_board.mark_shot(bad_coordinates[0],bad_coordinates[1])
    end
  end
end
