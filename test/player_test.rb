require './test/test_helper'
require './lib/player'
require './lib/game_board'
require './lib/ship'

class TestPlayer < Minitest::Test
  def setup
    @p = Player.new('Test')
    @p.game_board = GameBoard.new(4)
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
    assert_equal [0,0], @p.format_input("00")
  end

  def test_input_removes_special_characters
    assert_equal ["a","0"], @p.converted_input("a,0".chars)
    assert_equal ["b","1"], @p.converted_input("b,,.';1'".chars)
  end

  def test_digits_10_and_over_are_not_split
    assert_equal ["a","12"], @p.split(["a",",","1","2"])
    assert_equal ["b","26"], @p.split(["2","6",",","b"])
    assert_equal ["a","Z"], @p.split(["a"])
  end

  def test_format_strike_can_handle_different_forms_of_input
    assert_equal [0,0], @p.format_input("0,0")
    assert_equal [0,0], @p.format_input("a,0")
    assert_equal [1,0], @p.format_input("0,b")
    assert_equal [2,0], @p.format_input("c,0")
    assert_equal [0,0], @p.format_input("a0")
  end

  def test_player_input_is_validated
    assert_equal true, @p.valid_coordinates?(["a","0"])
    assert_equal false, @p.valid_coordinates?(["a","a"])
  end

  def test_player_gets_message_for_invalid_coordinates
    assert_respond_to @p, :coordinates_not_valid
  end

  def test_player_can_input_strike
    @p.game_board.mark_shot(0,1)
    assert_respond_to @p, :input
    assert_equal [0,0], @p.input
  end

  def test_error_message_displayed_when_bad_coordinates_are_entered
    assert_respond_to @p, :input
  end

  def test_program_automatically_generates_all_open_spaces
    coordinate = [0,0]
    assert_equal true, @p.all_clear(coordinate,"down")
    assert_equal false, @p.all_clear(coordinate,"up")
    assert_equal false, @p.all_clear(coordinate,"left")
    assert_equal true, @p.all_clear(coordinate,"right")
  end

  def test_valid_coordinates_are_generated_from_anchor_point
    coordinate = [0,0]
    assert_equal [[[1,0]],[[0,1]]], @p.generate_next_valid_coordinates_for_ship_placement(coordinate)
  end

  def test_player_can_place_ships
    ship = Ship.new
    @p.place_ship_on_board(ship)
    assert_equal [[0,0],[0,1]], @p.ships[0].placement
  end

end
