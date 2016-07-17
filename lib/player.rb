class Player
  attr_reader   :name
  attr_accessor :game_board

  def initialize(name)
    @name = name
  end

  def input_strike
    print "What are the coordinates of your strike?\n> "
    player_strike = gets.chomp
    player_strike.chars
  end

  def format_strike_input(player_input)
    player_input.chars.map { |char| char.to_i }
  end

end
