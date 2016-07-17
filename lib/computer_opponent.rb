class ComputerOpponent
  attr_reader :board_size

  def initialize(board_size)
    @board_size = board_size
  end

  def generate_strike
    [rand(board_size - 1), rand(board_size - 1)]
  end

  def computers_turn(game_board)
    loop do
      strike = generate_strike
      return strike if game_board.valid_shot?(strike[0], strike[1])
    end
  end

end
