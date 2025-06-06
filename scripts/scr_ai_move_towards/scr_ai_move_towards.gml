// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_ai_move_towards(unit, target){
	/// Move AI unit towards target
	/// @param {Id.Instance} unit - The AI unit
	/// @param {Id.Instance} target - The target unit
	calculate_movement_range(unit);

	var best_pos = [unit.grid_x, unit.grid_y];
	var best_distance = scr_hex_distance(unit.grid_x, unit.grid_y, target.grid_x, target.grid_y);
	var can_attack_after_move = false;

	// Check all valid movement positions
	with (obj_grid_manager) {
	    for (var q = 0; q < grid_width; q++) {
	        for (var r = 0; r < grid_height; r++) {
	            if (movement_grid[q][r] >= 0 && get_unit_at(q, r) == noone) {
	                // Check if we can attack the target from this position
	                var would_enable_attack = false;
	                var directions = get_hex_directions(r);
	                
	                for (var i = 0; i < array_length(directions); i++) {
	                    var attack_q = q + directions[i][0];
	                    var attack_r = r + directions[i][1];
	                    
	                    if (target.grid_x == attack_q && target.grid_y == attack_r) {
	                        would_enable_attack = true;
	                        break;
	                    }
	                }
	                
	                var distance = scr_hex_distance(q, r, target.grid_x, target.grid_y);
	                
	                // Prioritize positions that enable attack
	                if (would_enable_attack && (!can_attack_after_move || distance < best_distance)) {
	                    best_distance = distance;
	                    best_pos = [q, r];
	                    can_attack_after_move = true;
	                }
	                // If we haven't found an attack position, move closer
	                else if (!can_attack_after_move && distance < best_distance) {
	                    best_distance = distance;
	                    best_pos = [q, r];
	                }
	            }
	        }
	    }
	}

	// Move to best position
	if (best_pos[0] != unit.grid_x || best_pos[1] != unit.grid_y) {
	    // Set up movement path
	    ds_list_clear(unit.movement_path);
	    
	    // Start with target position
	    var current_q = best_pos[0];
	    var current_r = best_pos[1];
	    ds_list_add(unit.movement_path, [current_q, current_r]);
	    
	    // Trace back through movement grid to build path
	    var max_iterations = unit.movement_range * 2; // Safety limit
	    var iterations = 0;
	    
	    while (current_q != unit.grid_x || current_r != unit.grid_y) {
	        iterations++;
	        if (iterations > max_iterations) {
	            if (DEBUG) {
	                show_debug_message("AI pathfinding exceeded maximum iterations!");
	            }
	            ds_list_clear(unit.movement_path);
	            return;
	        }
	        
	        var found_next = false;
	        var current_value = obj_grid_manager.movement_grid[current_q][current_r];
	        var best_neighbor_cost = 999;
	        var best_neighbor_q = -1;
	        var best_neighbor_r = -1;
	        
	        with (obj_grid_manager) {
	            var directions = get_hex_directions(current_r);
	            for (var i = 0; i < array_length(directions); i++) {
	                var check_q = current_q + directions[i][0];
	                var check_r = current_r + directions[i][1];
	                
	                if (is_valid_position(check_q, check_r)) {
	                    var neighbor_cost = movement_grid[check_q][check_r];
	                    // Look for the neighbor with the lowest cost that's less than current
	                    if (neighbor_cost >= 0 && neighbor_cost < current_value && neighbor_cost < best_neighbor_cost) {
	                        best_neighbor_cost = neighbor_cost;
	                        best_neighbor_q = check_q;
	                        best_neighbor_r = check_r;
	                        found_next = true;
	                    }
	                }
	            }
	        }
	        
	        if (found_next) {
	            current_q = best_neighbor_q;
	            current_r = best_neighbor_r;
	            ds_list_insert(unit.movement_path, 0, [current_q, current_r]);
	        }
        
        // If we can't find the next step, something went wrong
        if (!found_next) {
            if (DEBUG) {
                show_debug_message("AI path finding failed! Current value: " + string(current_value));
                show_debug_message("Current position: " + string(current_q) + "," + string(current_r));
            }
            ds_list_clear(unit.movement_path);
            return;
        }
    }
    
    // Start movement animation
    unit.is_moving = true;
    unit.current_path_position = 0;
    unit.move_progress = 0;
    unit.has_moved = true;
    remove_unit_from_grid(unit);
    
    // Reset animation flags
    unit.skip_animation = false;
    
    // Skip animation after a short delay
    with (obj_game_manager) {
        alarm[1] = 30; // Set a timer to skip animation after 0.5 seconds
    }
    
    if (DEBUG) {
        show_debug_message("AI unit moving to " + string(best_pos[0]) + "," + string(best_pos[1]) + 
                          " (Can attack after move: " + string(can_attack_after_move) + ")");
    }
} else {
    if (DEBUG) {
        show_debug_message("AI unit couldn't find better position than current");
    }
}

scr_clear_highlights();
}