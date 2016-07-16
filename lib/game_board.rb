require 'pry'

class GameBoard
  attr_reader :current_game_board

  def initialize(board_size = 4)
    @board_size = board_size
    create_new_board
  end

  def create_new_board(new_size = @board_size)
    @board_size = new_size
    @current_game_board = []
    @board_size.times { @current_game_board << generate_line }
  end

  def generate_line
    line = Array.new
    @board_size.times { line << "." }
    line
  end

  def size
    current_game_board.length
  end

  def mark_shot(x_coordinate, y_cooridnate)
    if valid_shot?(x_coordinate, y_cooridnate)
      @current_game_board[x_coordinate][y_cooridnate] = 'S'
      return [x_coordinate, y_cooridnate]
    else
      return "Coordinates already shot"
    end
  end

  def valid_shot?(x_coordinate, y_cooridnate)
    return true unless @current_game_board[x_coordinate][y_cooridnate] == 'S'
  end

  def clear_game_board
    create_new_board
  end

end
