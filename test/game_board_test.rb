require './test/test_helper'
require './lib/game_board'

class TestGameBoard < Minitest::Test
  def setup
    @g = GameBoard.new
  end

  def test_game_board_can_be_created
    @g.create_new_board
    assert_equal 4, @g.size
  end

  def test_game_board_size_can_be_changed
    gameboard = GameBoard.new(6)
    gameboard.create_new_board
    assert_equal 6, gameboard.size
  end

  def test_game_board_size_is_4_by_default
    gameboard = GameBoard.new
    gameboard.create_new_board
    assert_equal 4, gameboard.size
  end

  def test_game_board_generates_lines_of_given_length
    assert_equal [".",".",".","."], @g.generate_line
  end

  def test_board_size_creates_an_array_of_given_length
    @g.create_new_board
    assert_equal [[".",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."]], @g.blank_game_board
  end

end
