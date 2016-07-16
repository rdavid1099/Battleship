require './test/test_helper'
require './lib/ship'

class TestShip < Minitest::Test
  def setup
    @s = Ship.new
  end

  def test_ship_has_a_default_size_of_the_smallest_unit
    assert_equal 2, @s.size
  end

  def test_ships_can_be_larger_than_two_units
    test_ship = Ship.new(4)
    test_ship2 = Ship.new(3)
    assert_equal 4, test_ship.size
    assert_equal 3, test_ship2.size
  end

  def test_ships_can_be_built
    assert_equal ['O','O'], @s.build_ship
  end

  def test_ships_start_with_no_damage
    assert_equal true, @s.undamaged?
  end

  def test_a_ship_can_be_shot
    @s.shot(0)
    assert_equal ['X','O'], @s.current_state
    assert_equal false, @s.undamaged?
  end

  def test_shot_must_hit_the_ship
    assert_equal true, @s.shot_hits_ship?(0)
    assert_equal false, @s.shot_hits_ship?(4)
  end

  def test_out_of_bounds_shot_does_not_register
    @s.shot(5)
    assert_equal ['O','O'], @s.current_state
    assert_equal true, @s.undamaged?
    @s.shot(1)
    assert_equal ['O','X'], @s.current_state
  end

  def test_ship_sinks_after_too_much_damage
    @s.shot(1)
    assert_equal ['O','X'], @s.current_state
    @s.shot(0)
    assert_equal ['X','X'], @s.current_state
    assert_equal true, @s.under_the_sea?
  end

  def test_large_ships_can_sink
    ship = Ship.new(4)
    ship.shot(0)
    ship.shot(1)
    ship.shot(2)
    assert_equal ['X','X','X','O'], ship.current_state
    assert_equal false, ship.under_the_sea?
    ship.shot(3)
    assert_equal ['X','X','X','X'], ship.current_state
    assert_equal true, ship.under_the_sea?
  end

  def test_sunken_ships_cannot_be_shot
    @s.shot(0)
    @s.shot(1)
    assert_equal false, @s.shot_hits_ship?(1)
  end

  def test_ships_return_health_percentage
    assert_equal 100, @s.health_left_percentage
    @s.shot(1)
    assert_equal 50, @s.health_left_percentage
  end

  def test_large_ships_return_health_percentage
    ship = Ship.new(3)
    ship_2 = Ship.new(5)
    ship.shot(0)
    ship.shot(1)
    assert_equal 33, ship.health_left_percentage
    ship_2.shot(4)
    ship_2.shot(3)
    ship_2.shot(2)
    assert_equal 40, ship_2.health_left_percentage
  end

  def test_ships_display_remaining_health_bar
    assert_equal "[********************]", @s.health_bar
    @s.shot(1)
    assert_equal "[**********          ]", @s.health_bar
  end

  def test_large_ships_display_remaining_health_bar
    ship = Ship.new(6)
    ship.shot(0)
    ship.shot(1)
    assert_equal "[*************       ]", ship.health_bar
    ship.shot(2)
    assert_equal "[**********          ]", ship.health_bar
    ship.shot(3)
    assert_equal "[******              ]", ship.health_bar
  end

  def test_sunken_ships_display_sad_health_bar
    @s.shot(0)
    @s.shot(1)
    assert_equal "[xX UNDER THE SEA! Xx]", @s.health_bar
  end
end
