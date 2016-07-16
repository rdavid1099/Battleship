require './test/test_helper'
require './lib/player'

class TestPlayer < Minitest::Test
  def setup
    @p = Player.new('Test')
  end

  def test_player_can_be_created_with_name
    assert_equal 'Test', @p.name
  end
end
