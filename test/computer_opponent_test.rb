require './test/test_helper'
require './lib/computer_opponent'
require './lib/game_board'
require './lib/ship'

class TestComputerOpponent < Minitest::Test
  def setup
    @compy = ComputerOpponent.new(GameBoard.new)
    @compy.add_ship(Ship.new)
  end

  def test_a_computer_opponent_can_be_initialized
    assert_instance_of ComputerOpponent, @compy
  end

  def test_computer_opponent_is_initialized_knowing_the_size_of_the_board
    assert_equal 4, @compy.game_board.size
  end

  def test_computer_generates_strike_positions
    assert_respond_to @compy, :generate_strike
  end

  def test_computers_strike_is_within_the_bounds_of_the_board
    assert_equal true, @compy.generate_strike[0] < 4
    assert_equal true,  @compy.generate_strike[1] < 4
  end

  def test_computer_strikes_are_registered_by_the_game_board
    skip
    board = GameBoard.new(4)
    strike_1 = @compy.generate_strike
    assert_equal true, board.valid_shot?(strike_1[0], strike_1[1])
    board.mark_shot(strike_1[0], strike_1[1])
    strike_2 = @compy.generate_strike
    board.mark_shot(strike_2[0], strike_2[1])
    assert_equal 2, board.total_number_of_shots
  end

  def test_computer_keeps_generating_targets_until_it_lands_a_valid_shot
    @compy.game_board.mark_shot(0,0)
    @compy.game_board.mark_shot(0,1)
    @compy.game_board.mark_shot(0,2)
    @compy.game_board.mark_shot(0,3)
    computer_strike = @compy.computers_turn
    assert_equal true, computer_strike[0] != 0
  end

  def test_ships_can_be_added_to_computers_fleet
    @compy.add_ship(Ship.new)
    assert_equal 2, @compy.ships.length
  end

  def test_computer_randomly_generates_ship_anchor_point
    @compy.current_ship = Ship.new
    assert_equal 2, @compy.get_first_placement.length
  end

  def test_computer_randomly_generates_rest_of_ship_placement
    skip
    @compy.current_ship = Ship.new
    next_placement_options = [[[1,0]],[[0,1]]]
    assert_equal [[1,0]], @compy.computer_chooses_ship_placement(next_placement_options)
  end

  def test_computer_generates_complete_ship_placement
    assert_equal nil, @compy.ships[0].placement
    @compy.generate_ship_locations
    assert_equal 2, @compy.ships[0].placement.length
  end

  def test_computer_can_place_two_ships
    @compy.add_ship(Ship.new(3))
    assert_equal nil, @compy.ships[0].placement
    assert_equal nil, @compy.ships[1].placement
    @compy.generate_ship_locations
    assert_equal 2, @compy.ships[0].placement.length
    assert_equal 3, @compy.ships[1].placement.length
    assert_equal 5, @compy.all_ship_placements.length
  end

  def test_computers_downed_ships_are_displayed
    skip
    @compy.add_ship(Ship.new(3))
    @compy.add_ship(Ship.new)
    @compy.ships[1].shot(0)
    @compy.ships[1].shot(1)
    @compy.ships[1].shot(2)
    assert @compy.display_downed_ships
  end

end
