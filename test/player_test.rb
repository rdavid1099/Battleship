require './test/test_helper'
require './lib/player'
require './lib/game_board'
require './lib/ship'

class TestPlayer < Minitest::Test
  def setup
    @p = Player.new('Test')
    @p.game_board = GameBoard.new(4)
    @p.add_ship(Ship.new)
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
    assert_equal [0,0], @p.format_input("1,1")
    assert_equal [0,0], @p.format_input("a,1")
    assert_equal [1,0], @p.format_input("1,b")
    assert_equal [2,0], @p.format_input("c,1")
    assert_equal [0,0], @p.format_input("a1")
  end

  def test_player_input_is_validated
    assert_equal true, @p.valid_coordinates?(["a","1"])
    assert_equal false, @p.valid_coordinates?(["a","0"])
    assert_equal false, @p.valid_coordinates?(["a","a"])
  end

  def test_player_gets_message_for_invalid_coordinates
    assert_respond_to @p, :coordinates_not_valid
  end

  def test_player_can_input_coordinates
    @p.game_board.mark_shot(0,1)
    assert_respond_to @p, :input
    assert_equal [0,0], @p.input
  end

  def test_error_message_displayed_when_bad_coordinates_are_entered
    assert_respond_to @p, :input
  end

  def test_program_automatically_generates_all_open_spaces
    coordinate = [0,0]
    @p.current_ship = Ship.new
    assert_equal true, @p.all_clear(coordinate,"down")
    assert_equal false, @p.all_clear(coordinate,"up")
    assert_equal false, @p.all_clear(coordinate,"left")
    assert_equal true, @p.all_clear(coordinate,"right")
  end

  def test_valid_coordinates_are_generated_from_anchor_point
    coordinate = [0,0]
    @p.current_ship = Ship.new
    assert_equal [[[1,0]],[[0,1]]], @p.generate_next_valid_coordinates_for_ship_placement(coordinate)
  end

  def test_valid_coordinates_generated_from_different_anchor_point
    anchor_point = [1,1]
    @p.current_ship = Ship.new
    assert_equal [[[0, 1]],[[2, 1]],[[1,0]],[[1,2]]], @p.generate_next_valid_coordinates_for_ship_placement(anchor_point)

  end

  def test_valid_coordinates_are_generated_for_larger_ships
    @p.current_ship = Ship.new(4)
    anchor_point = [0,0]
    assert_equal [[[1, 0],[2, 0],[3, 0]],[[0, 1],[0, 2],[0, 3]]], @p.generate_next_valid_coordinates_for_ship_placement(anchor_point)
  end

  def test_converting_array_to_english_string_of_coordinates
    coordinate = [[1,0]]
    assert_equal "  B,1 ", @p.convert_cordinate_to_text(coordinate)
  end

  def test_menu_generated_of_remaining_placements
    coordinate = [0,0]
    @p.current_ship = Ship.new
    next_placement_options = [[[1,0]],[[0,1]]]
    assert_equal "Please select the placement you would like for this 2 unit ship\n1)  B,1 \n2)  A,2 \n> ", @p.remaining_placement_menu(next_placement_options)
  end

  def test_menu_generates_for_ship_with_more_options
    anchor_point = [1,1]
    @p.current_ship = Ship.new
    next_placement_options = [[[0, 1]],[[2, 1]],[[1,0]],[[1,2]]]
    assert_equal "Please select the placement you would like for this 2 unit ship\n1)  A,2 \n2)  C,2 \n3)  B,1 \n4)  B,3 \n> ", @p.remaining_placement_menu(next_placement_options)
  end

  def test_menu_generates_for_larger_ships
    @p.current_ship = Ship.new(4)
    anchor_point = [0,0]
    next_placement_options = [[[1, 0],[2, 0],[3, 0]],[[0, 1],[0, 2],[0, 3]]]
    assert_equal "Please select the placement you would like for this 2 unit ship\n1)  B,1  C,1  D,1 \n2)  A,2  A,3  A,4 \n> ", @p.remaining_placement_menu(next_placement_options)
  end

  def test_player_can_place_ships
    @p.place_ship_on_board
    assert_equal [[0,0],[0,1]], @p.ships[0].placement
  end

  def test_player_cannot_place_ship_in_crowded_surroundings
    @p.current_ship = Ship.new
    assert_equal true, @p.surroundings_are_clear([0,0])
    @p.update_all_ship_placements([[0,1],[1,0]])
    assert_equal false, @p.surroundings_are_clear([0,0])
  end

  def test_player_can_place_two_ships
    @p.update_all_ship_placements([[2,0],[2,1],[2,2][2,3]])
    @p.place_ship_on_board
    assert_equal [[0,0],[0,1]], @p.ships[0].placement
  end

  def test_player_ships_can_be_damaged
    @p.add_ship(Ship.new(4))
    @p.ships[0].place_on_game_board([[0,0],[0,1],[0,2],[0,3]])
    @p.ship_damaged([0,2])
    assert_equal ["O","O","X","O"], @p.ships[0].current_state
  end

end
