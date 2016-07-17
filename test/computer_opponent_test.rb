require './test/test_helper'
require './lib/computer_opponent'
require './lib/game_board'

class TestComputerOpponent < Minitest::Test
  def setup
    @compy = ComputerOpponent.new(4)
  end

  def test_a_computer_opponent_can_be_initialized
    assert_instance_of ComputerOpponent, @compy
  end

  def test_computer_opponent_is_initialized_knowing_the_size_of_the_board
    assert_equal 4, @compy.board_size
  end

  def test_computer_generates_strike_positions
    assert_respond_to @compy, :generate_strike
  end

  def test_computers_strike_is_within_the_bounds_of_the_board
    assert_equal true, @compy.generate_strike[0] < 4
    assert_equal true,  @compy.generate_strike[1] < 4
  end

  def test_computer_strikes_are_registered_by_the_game_board
    board = GameBoard.new(4)
    strike_1 = @compy.generate_strike
    assert_equal true, board.valid_shot?(strike_1[0], strike_1[1])
    board.mark_shot(strike_1[0], strike_1[1])
    strike_2 = @compy.generate_strike
    assert_equal true, board.valid_shot?(strike_2[0], strike_2[1])
    board.mark_shot(strike_2[0], strike_2[1])
    assert_equal 2, board.total_number_of_shots
  end

  def test_computer_keeps_generating_targets_until_it_lands_a_valid_shot
    board = GameBoard.new(2)
    board.mark_shot(0,0)
    board.mark_shot(0,1)
    board.mark_shot(1,1)
    assert_equal [1,0], @compy.computers_turn(board)
  end

end
