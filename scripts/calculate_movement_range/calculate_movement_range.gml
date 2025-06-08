// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function calculate_movement_range(unit){
	/// Calculate valid movement positions for a unit
	/// @param {Id.Instance} unit - The unit to calculate movement for
	with (obj_grid_manager) {
    // Clear movement grid and only movement highlights (value 1), preserve attack highlights (value 2)
    for (var i = 0; i < grid_width; i++) {
        for (var j = 0; j < grid_height; j++) {
            movement_grid[i][j] = -1;
            if (highlight_grid[i][j] == 1) {
                highlight_grid[i][j] = 0;
            }
        }
    }

    // Flood fill algorithm for movement range with terrain costs
    var queue = ds_queue_create();
    ds_queue_enqueue(queue, [unit.grid_x, unit.grid_y, 0]);
    movement_grid[unit.grid_x][unit.grid_y] = 0;

    while (!ds_queue_empty(queue)) {
        var current = ds_queue_dequeue(queue);
        var q = current[0];
        var r = current[1];
        var dist = current[2];
        
        if (dist < unit.movement_range) {
            var neighbors = get_hex_neighbors(q, r);
            for (var i = 0; i < array_length(neighbors); i++) {
                var nq = neighbors[i][0];
                var nr = neighbors[i][1];
                
                if (is_valid_position(nq, nr) && movement_grid[nq][nr] == -1) {
                    var unit_at_position = get_unit_at(nq, nr);
                    var can_pass_through = false;
                    
                    // Check if unit can pass through based on movement type
                    if (unit_at_position == noone) {
                        // No unit at position - always passable
                        can_pass_through = true;
                    } else {
                        // Unit at position - check movement type
                        switch(unit.move_type) {
                            case MOVETYPE.GROUND:
                                // Ground units blocked by all other units
                                can_pass_through = false;
                                break;
                                
                            case MOVETYPE.SKYLOW:
                                // Sky low units blocked by all other units (cannot pass through)
                                can_pass_through = false;
                                break;
                                
                            case MOVETYPE.SKYHIGH:
                                // Sky high units can pass over other units
                                can_pass_through = true;
                                break;
                                
                            default:
                                can_pass_through = false;
                                break;
                        }
                    }
                    
                    if (can_pass_through) {
                        // Calculate terrain-based movement cost
                        var terrain_type = get_terrain_at(nq, nr);
                        var movement_cost = get_terrain_movement_cost(unit, terrain_type);
                        var new_dist = dist + movement_cost;
                        
                        // Only add to queue if within movement range
                        if (new_dist <= unit.movement_range) {
                            movement_grid[nq][nr] = new_dist;
                            // Only set movement highlight if there's no attack highlight and no unit at final position
                            // (All flying units cannot land on other units)
                            if (highlight_grid[nq][nr] != 2) {
                                if (unit_at_position == noone) {
                                    highlight_grid[nq][nr] = 1; // Blue highlight for movement
                                }
                            }
                            ds_queue_enqueue(queue, [nq, nr, new_dist]);
                        }
                    }
                }
            }
        }
    }

    ds_queue_destroy(queue);
    
    // No longer need surface update tracking for sprite-based rendering
}
}