require 'colorize'

class GameBoard
  attr_reader :current_game_board,
              :total_number_of_shots,
              :total_number_of_hits

  def initialize(board_size = 4)
    @board_size = board_size
    @total_number_of_shots = 0
    @total_number_of_hits = 0
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

  def mark_ship_location(ship_coordinates)
    ship_coordinates.each do |coordinate|
      @current_game_board[coordinate[0]][coordinate[1]] = 'O'
    end
  end

  def mark_shot(y_cooridnate, x_cooridnate)
    if valid_shot?(y_cooridnate, x_cooridnate)
      unless @current_game_board[y_cooridnate][x_cooridnate] == 'O'
        @current_game_board[y_cooridnate][x_cooridnate] = 'M'.yellow
      else
        mark_hit(y_cooridnate, x_cooridnate)
      end
      @total_number_of_shots += 1
      return [y_cooridnate, x_cooridnate]
    else
      return "Coordinates already shot\n> "
    end
  end

  def mark_hit(y_coordinate, x_cooridnate)
    @current_game_board[y_coordinate][x_cooridnate] = 'H'.red
    @total_number_of_hits += 1
    @total_number_of_shots += 1
  end

  def valid_shot?(y_coordinate, x_cooridnate)
    unless shot_out_of_bounds?(y_coordinate, x_cooridnate)
      return true if @current_game_board[y_coordinate][x_cooridnate] == '.' || @current_game_board[y_coordinate][x_cooridnate] == 'O'
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
