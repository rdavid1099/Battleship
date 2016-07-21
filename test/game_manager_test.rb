require './test/test_helper'
require './lib/game_manager'

class TestGameManager < Minitest::Test
  def setup
    @game = GameManager.new
  end

  def test_game_manager_determines_if_y_or_n_answers_are_valid
    assert_equal true, @game.yes_or_no_confirmed?('y')
    assert_equal true, @game.yes_or_no_confirmed?('n')
  end

  def test_difficulty_is_initially_set_at_zero
    assert_equal 1, @game.difficulty
  end

  def test_game_manager_can_create_new_player
    skip
    @game.launch
    assert_equal 'TESTING', @game.player.name
  end

  def test_game_manager_sets_up_game_board_when_it_launches
    skip
    new_game = GameManager.new.launch
    assert_instance_of GameBoard, new_game.game_board
  end

  def test_game_manager_creates_computer_opponent
    skip
    @game.launch
    assert_instance_of ComputerOpponent, @game.computer_opponent
  end

  def test_game_manager_starts_the_round
    assert_respond_to @game, :start_game
  end

  def test_game_manager_title_screen_returns_ascii_art
    assert_equal '  ______  ___ _____ _____ _     _____ _____ _   _ ___________
  | ___ \/ _ |_   _|_   _| |   |  ___/  ___| | | |_   _| ___ \
  | |_/ / /_\ \| |   | | | |   | |__ \ `--.| |_| | | | | |_/ /
  | ___ |  _  || |   | | | |   |  __| `--. |  _  | | | |  __/
  | |_/ | | | || |   | | | |___| |___/\__/ | | | |_| |_| |
  \____/\_| |_/\_/   \_/ \_____\____/\____/\_| |_/\___/\_|', @game.title_screen
  end

  def test_welcome_message_guides_player_to_destination
    skip
    assert_equal "p", @game.welcome_menu
  end

  def test_manager_builds_necessary_ships
    skip
    @game.launch
    @game.build_ships
    assert_equal 2, @game.player.ships.length
    assert_equal 3, @game.player.ships[1].size
    assert_equal 2, @game.computer_opponent.ships.length
    assert_equal 2, @game.computer_opponent.ships[0].size
  end

  def test_ships_are_placed_on_board_after_being_built
    skip
    @game.launch
    @game.setup_round
    assert_equal 5, @game.player.all_ship_placements.length
    assert_equal 5, @game.computer_opponent.all_ship_placements.length
  end

  def test_game_menu_input_is_validated
    assert_equal 'f', @game.validate_menu_input('f')
    assert_equal 'a', @game.validate_menu_input('attack')
  end

  def test_main_game_display_looks_correct
    skip
    @game.launch
    refute @game.main_game_display
  end

  def test_player_fleet_is_displayed_properly
    skip
    @game.launch
    @game.build_ships
    assert @game.display_player_fleet_status
  end

  def test_game_stats_displayed_correctly
    skip
    @game.launch
    @game.player.game_board.mark_shot(0,0)
    @game.player.game_board.mark_shot(1,1)
    @game.player.game_board.mark_hit(1,0)
    refute @game.game_stats
  end

end
