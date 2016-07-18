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

  def status
    "#{visual_ship}: Remaining Health #{health_bar} #{health_left_percentage}%"
  end

  def health_left_percentage
    ((remaining_health / size.to_f) * 100).round
  end

  def remaining_health
    @current_state.find_all { |damage| damage == 'O' }.length
  end

  def health_bar
    return "[xX UNDER THE SEA! Xx]" if under_the_sea?
    health_bar_length = health_left_percentage/5
    empty_space = 20 - health_bar_length
    "[" + "*"*health_bar_length + " "*empty_space + "]"
  end

  def visual_ship
    ship_display = ["<="]
    @current_state.each { |damage| ship_display << "#{damage}=" }
    ship_display.join + ">"
  end
end
