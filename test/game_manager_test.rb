require './test/test_helper'
require './lib/game_manager'

class TestGameManager < Minitest::Test
  def setup
    @game = GameManager.new
  end

  def test_game_manager_determines_if_y_or_n_answers_are_valid
    assert_equal true, @game.yes_or_no_confirmed?('y')
    assert_equal true, @game.yes_or_no_confirmed?('n')
    assert_equal false, @game.yes_or_no_confirmed?('r')
  end

  def test_difficulty_is_initially_set_at_zero
    assert_equal 1, @game.difficulty
  end

  def test_game_manager_confirms_player_name
    assert_equal 'TESTING', @game.confirm_player_name('TESTING')
  end

  def test_game_manager_can_create_new_player
    @game.launch
    assert_equal 'TESTING', @game.player.name
  end

  def test_game_manager_sets_up_game_board_when_it_launches
    new_game = GameManager.new.launch
    assert_instance_of GameBoard, new_game.game_board
  end

  def test_game_manager_creates_computer_opponent
    @game.launch
    assert_instance_of ComputerOpponent, @game.computer_opponent
  end

  def test_game_manager_starts_the_round
    assert_respond_to @game, :start_game
  end

  def test_game_manager_title_screen_returns_ascii_art
    assert_equal '______  ___ _____ _____ _     _____ _____ _   _ ___________
  | ___ \/ _ |_   _|_   _| |   |  ___/  ___| | | |_   _| ___ \
  | |_/ / /_\ \| |   | | | |   | |__ \ `--.| |_| | | | | |_/ /
  | ___ |  _  || |   | | | |   |  __| `--. |  _  | | | |  __/
  | |_/ | | | || |   | | | |___| |___/\__/ | | | |_| |_| |
  \____/\_| |_/\_/   \_/ \_____\____/\____/\_| |_/\___/\_|', @game.title_screen
  end

  def test_welcome_message_guides_player_to_destination
    assert_equal "p", @game.welcome_menu
  end

  def test_manager_builds_necessary_ships
    @game.launch
    @game.build_ships
    assert_equal 2, @game.player.ships.length
    assert_equal 3, @game.player.ships[1].size
    assert_equal 2, @game.computer_opponent.ships.length
    assert_equal 2, @game.computer_opponent.ships[0].size
  end

  def test_ships_are_placed_on_board_after_being_built
    @game.launch
    @game.setup_round
    assert_equal 5, @game.player.all_ship_placements.length
    assert_equal 5, @game.computer_opponent.all_ship_placements.length
  end

end
