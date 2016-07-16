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

  def test_board_recognizes_out_of_bound_shots
    assert_equal false, @g.shot_out_of_bounds?(0,0)
    assert_equal true, @g.shot_out_of_bounds?(94,35)
  end

  def test_shot_validity_doesnt_allow_out_of_bound_shots
    assert_equal false, @g.valid_shot?(92,53)
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

  def test_game_board_generates_display
    assert_respond_to @g, :generate_current_display
  end

  def test_game_board_generates_border_relevant_to_board_size
    @g.create_new_board(2)
    assert_equal "========\n", @g.generate_border
    @g.create_new_board(3)
    assert_equal "===========\n", @g.generate_border
  end

  def test_game_board_genernates_column_numbers_relevant_to_board_size
    @g.create_new_board(2)
    assert_equal ".  1  2 \n", @g.generate_column_numbers
    @g.create_new_board(3)
    assert_equal ".  1  2  3 \n", @g.generate_column_numbers
  end

  def test_game_board_generates_a_line_of_the_display
    @g.create_new_board(1)
    assert_equal "A    \n", @g.generate_display_lines
  end

  def test_game_generates_two_lines_of_the_display
    @g.create_new_board(2)
    assert_equal "A       \nB       \n", @g.generate_display_lines
  end

  def test_game_board_displays_2x2_board
    @g.create_new_board(2)
    assert_equal "========\n.  1  2 \nA       \nB       \n========\n", @g.generate_current_display
  end

  def test_game_board_displays_4x4_board
    assert_equal "==============\n.  1  2  3  4 \nA             \nB             \nC             \nD             \n==============\n", @g.generate_current_display
  end

  def test_board_evaluates_shots_on_given_display_line
    @g.create_new_board(2)
    @g.mark_shot(0,0)
    assert_equal "A  S    \n", @g.evaluate_shots_on_line(0)
  end

  def test_game_board_display_lines_update_after_shot_fired
    @g.create_new_board(2)
    @g.mark_shot(0,0)
    assert_equal "========\n.  1  2 \nA  S    \nB       \n========\n", @g.generate_current_display
    @g.mark_shot(1,1)
    assert_equal "========\n.  1  2 \nA  S    \nB     S \n========\n", @g.generate_current_display
    @g.mark_shot(0,1)
    assert_equal "========\n.  1  2 \nA  S  S \nB     S \n========\n", @g.generate_current_display
  end

  def test_board_receives_strikes_that_hit
    @g.mark_hit(0,0)
    assert_equal [["H",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."],
                  [".",".",".","."]], @g.current_game_board
  end

  def test_board_receives_shots_and_hits
    @g.mark_shot(0,0)
    @g.mark_hit(1,0)
    @g.mark_hit(2,1)
    @g.mark_shot(2,2)
    assert_equal [["S",".",".","."],
                  ["H",".",".","."],
                  [".","H","S","."],
                  [".",".",".","."]], @g.current_game_board
  end

  def test_strikes_are_invalid_if_hit_marked_on_spot
    @g.mark_hit(0,0)
    assert_equal false, @g.valid_shot?(0,0)
  end

  def test_game_board_displays_hits_and_shots
    @g.mark_shot(0,0)
    @g.mark_hit(1,0)
    @g.mark_hit(2,1)
    @g.mark_shot(2,2)
    assert_equal "==============\n.  1  2  3  4 \nA  S          \nB  H          \nC     H  S    \nD             \n==============\n", @g.generate_current_display
  end
end
