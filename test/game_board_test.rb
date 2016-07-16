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
                  [".",".",".","."]], @g.current_game_board
  end

  def test_game_board_automatically_generated_when_initialized
    gameboard = GameBoard.new
    assert_equal [[".",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."]], @g.current_game_board
  end

  def test_game_board_size_changes_depending_on_initialize_size
    gameboard = GameBoard.new(3)
    assert_equal [[".",".","."],
                  [".",".","."],
                  [".",".","."]], gameboard.current_game_board
  end

  def test_game_board_can_also_be_manually_generated
    gameboard = GameBoard.new
    assert_equal [[".",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."]], gameboard.current_game_board
    gameboard.create_new_board(3)
    assert_equal [[".",".","."],
                  [".",".","."],
                  [".",".","."]], gameboard.current_game_board
    gameboard.create_new_board(4)
    assert_equal [[".",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."]], gameboard.current_game_board
  end

  def test_board_marks_shots_fired
    @g.mark_shot(0,0)
    assert_equal [["S",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."]], @g.current_game_board
  end

  def test_board_marks_two_shots
    @g.mark_shot(0,0)
    @g.mark_shot(1,2)
    assert_equal [["S",".",".","."],
                  [".",".","S","."],
                  [".",".",".","."],
                  [".",".",".","."]], @g.current_game_board
  end

  def test_board_marks_five_shots
    @g.mark_shot(0,2)
    @g.mark_shot(1,3)
    @g.mark_shot(3,2)
    @g.mark_shot(0,1)
    @g.mark_shot(1,2)
    assert_equal [[".","S","S","."],
                  [".",".","S","S"],
                  [".",".",".","."],
                  [".",".","S","."]], @g.current_game_board
  end

  def test_board_determines_if_shot_is_valid
    @g.mark_shot(0,0)
    refute @g.valid_shot?(0,0)
    assert @g.valid_shot?(1,1)
  end

  def test_board_allows_shot_unless_its_not_valid
    @g.mark_shot(0,0)
    refute @g.valid_shot?(0,0)
    assert_equal "Coordinates already shot", @g.mark_shot(0,0)
  end

  def test_board_returns_coordinates_if_shot_is_valid_and_marked
    assert_equal [0,0], @g.mark_shot(0,0)
    assert_equal [1,2], @g.mark_shot(1,2)
    assert_equal [3,3], @g.mark_shot(3,3)
    assert_equal "Coordinates already shot", @g.mark_shot(1,2)
  end

  def test_game_board_can_be_cleared
    @g.clear_game_board
    assert_equal [[".",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."]], @g.current_game_board
  end
end
