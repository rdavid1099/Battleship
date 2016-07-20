module CoordinateManager

  def generate_next_valid_coordinates_for_ship_placement(anchor_point)
    all_possible_placements = Array.new
    all_possible_placements << @placements if all_clear(anchor_point, "up")
    all_possible_placements << @placements if all_clear(anchor_point, "down")
    all_possible_placements << @placements if all_clear(anchor_point, "left")
    all_possible_placements << @placements if all_clear(anchor_point, "right")
    return all_possible_placements
  end

  def all_clear(anchor_point, direction)
    y_coord = anchor_point[0]
    x_coord = anchor_point[1]
    @placements = []
    (current_ship.size - 1).times { @placements << [(y_coord -= 1), x_coord] } if direction == "up"
    (current_ship.size - 1).times { @placements << [(y_coord += 1), x_coord] } if direction == "down"
    (current_ship.size - 1).times { @placements << [y_coord, (x_coord -= 1)] } if direction == "left"
    (current_ship.size - 1).times { @placements << [y_coord, (x_coord += 1)] } if direction == "right"
    @placements.all? { |coordinate| coordinates_clear?(coordinate) && game_board.shot_out_of_bounds?(coordinate[0],coordinate[1]) == false }
  end

  def coordinates_clear?(coordinates)
    return true if @all_ship_placements.empty?
    @all_ship_placements.none? { |prev_coordinate| prev_coordinate == coordinates}
  end

  def surroundings_are_clear(coordinates)
    all_clear(coordinates, "right") || all_clear(coordinates, "left") || all_clear(coordinates, "up") || all_clear(coordinates, "down")
  end

  def reset
    @ships = []
    @all_ship_placements = []
    game_board.clear_game_board
  end

end
