class Player
  attr_reader   :name
  attr_accessor :game_board

  def initialize(name)
    @name = name
  end

  def input_strike
    player_strike = String.new
    loop do
      # print "What are the coordinates of your strike?\n> "
      # player_strike = gets.chomp.downcase
      player_strike = "a,0"
      player_strike = format_strike_input(player_strike)
      break unless player_strike == nil
    end
    player_strike
  end

  def format_strike_input(player_input)
    player_coordinates = converted_input(player_input.chars)
    return nil if player_coordinates == nil
    player_coordinates.map do |char|
      char = char.ord - 97 if char =~ /[a-z]/
      char.to_i
    end
  end

  def converted_input(input)
    formatted_input = input.map { |char| char if char =~ /[a-z0-9]/ }.compact
    return coordinates_not_valid unless valid_coordinates?(formatted_input)
    formatted_input.reverse! if formatted_input[0] =~ /[0-9]/
    formatted_input
  end

  def valid_coordinates?(input)
    !input.all? { |char| char =~ /[a-z]/ }
  end

  def coordinates_not_valid
    puts "You must enter valid coordinates i.e.: 'A,0'."
  end

end
