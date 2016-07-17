require './test/test_helper'
require './lib/player'
require './lib/game_board'

class TestPlayer < Minitest::Test
  def setup
    @p = Player.new('Test')
  end

  def test_player_can_be_created_with_name
    assert_equal 'Test', @p.name
  end

  def test_player_can_have_see_the_instance_of_the_game_board
    board = GameBoard.new(4)
    @p.game_board = board
    assert_instance_of GameBoard, @p.game_board
  end

  def test_players_game_board_is_updated
    board = GameBoard.new
    @p.game_board = board
    board.mark_shot(0,0)
    assert_equal 1, @p.game_board.total_number_of_shots
  end

  def test_player_input_is_formatted_correctly
    assert_equal [0,0], @p.format_strike_input("00")
  end

  def test_format_strike_can_handle_different_forms_of_input
    assert_equal [0,0], @p.format_strike_input("0,0")
    assert_equal [0,0], @p.format_strike_input("a,0")
    assert_equal [1,0], @p.format_strike_input("0,b")
    assert_equal [0,0], @p.format_strike_input("A,0")
    assert_equal [0,0], @p.format_strike_input("A0")
  end

  # def test_player_can_input_strike
  #   assert_respond_to @p, :input_strike
  #   assert_equal [0,0], @p.input_strike
  # end

end
