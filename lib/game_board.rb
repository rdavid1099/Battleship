require 'pry'

class GameBoard
  attr_reader :current_game_board,
              :total_number_of_shots

  def initialize(board_size = 4)
    @board_size = board_size
    @total_number_of_shots = 0
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

  def mark_shot(y_cooridnate, x_cooridnate)
    if valid_shot?(y_cooridnate, x_cooridnate)
      @current_game_board[y_cooridnate][x_cooridnate] = 'S'
      @total_number_of_shots += 1
      return [y_cooridnate, x_cooridnate]
    else
      return "Coordinates already shot"
    end
  end

  def mark_hit(y_coordinate, x_cooridnate)
    if valid_shot?(y_coordinate, x_cooridnate)
      @current_game_board[y_coordinate][x_cooridnate] = 'H'
      @total_number_of_shots += 1
      return [y_coordinate, x_cooridnate]
    else
      return "Coordinates already shot"
    end
  end

  def valid_shot?(y_coordinate, x_cooridnate)
    unless shot_out_of_bounds?(y_coordinate, x_cooridnate)
      return true if @current_game_board[y_coordinate][x_cooridnate] == '.'
    end
    false
  end

  def shot_out_of_bounds?(y_coordinate, x_cooridnate)
    return true if y_coordinate < 0 || x_cooridnate < 0
    y_coordinate >= size || x_cooridnate >= size
  end

  def clear_game_board
    create_new_board
  end

  def generate_current_display
    generate_border +
    generate_column_numbers +
    generate_display_lines +
    generate_border
  end

  def generate_border
    "==" + "="*(size*3) + "\n"
  end

  def generate_column_numbers
    column_numbers = ". "
    counter = 1
    size.times do
      column_numbers += " #{counter} "
      counter += 1
    end
    column_numbers + "\n"
  end

  def generate_display_lines
    display_line = Array.new
    size.times { display_line << evaluate_shots_on_line(display_line.length) }
    display_line.join
  end

  def evaluate_shots_on_line(line_num)
    line = @current_game_board[line_num].map { |space| space == "." ? "   " : " #{space} " }
    "#{(65 + line_num).chr} #{line.join}\n"
  end

end
