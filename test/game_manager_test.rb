require './test/test_helper'
require './lib/game_manager'

class TestGameManager < Minitest::Test
  def setup
    @game = GameManager.new
  end

  def test_game_manager_determines_if_y_or_n_answers_are_valid
    assert_equal true, @game.yes_or_no_confirmed?('y')
    assert_equal true, @game.yes_or_no_confirmed?('n')
    #assert_equal false, @game.yes_or_no_confirmed?('r')
  end

  def test_game_manager_confirms_player_name
    assert_equal 'TESTING', @game.confirm_player_name('TESTING')
  end

  def test_game_manager_can_create_new_player
    @game.create_new_player
    assert_equal 'TESTING', @game.player.name
  end

  def test_game_manager_creates_new_player_when_initialized
    new_game = GameManager.new
    assert_equal 'TESTING', @game.player.name
  end

  def test_game_manager_sets_up_game_board
    new_game = GameManager.new
    assert_instance_of GameBoard, new_game.game_board
  end

end
