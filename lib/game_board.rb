class GameBoard
  attr_reader :blank_game_board

  def initialize(board_size = 4)
    @board_size = board_size
    @blank_game_board = Array.new
  end

  def create_new_board
    @board_size.times { @blank_game_board << generate_line }
  end

  def generate_line
    line = Array.new
    @board_size.times { line << "." }
    line
  end

  def size
    blank_game_board.length
  end

end
