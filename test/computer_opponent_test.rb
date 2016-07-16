require './test/test_helper'
require './lib/computer_opponent'

class TestComputerOpponent < Minitest::Test
  def setup
    @compy = ComputerOpponent.new
  end

  def test_a_computer_opponent_can_be_initialized
    assert_instance_of ComputerOpponent, @compy
  end
end
