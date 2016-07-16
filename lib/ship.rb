class Ship
  attr_reader :size,
              :current_state

  def initialize(size = 2)
    @size = size
    @current_state = build_ship
  end

  def build_ship
    new_ship = Array.new
    size.times { new_ship << "O" }
    new_ship
  end

  def undamaged?
    @current_state.all? { |location| location == 'O'}
  end

  def under_the_sea?
    @current_state.all? { |damage| damage == 'X' }
  end

  def shot(location)
    @current_state[location] = 'X' if shot_hits_ship?(location)
  end

  def shot_hits_ship?(location)
    location < size && @current_state[location] != 'X'
  end
end
