// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function scr_unit_handle_action(unit, target_q, target_r){
	/// Handle unit action based on target position
	/// @param {Id.Instance} unit - The unit performing the action
	/// @param {Real} target_q - Target hex Q coordinate
	/// @param {Real} target_r - Target hex R coordinate
	if (!is_valid_position(target_q, target_r)) {
	    scr_unit_deselect(unit);
	    return;
	}

	var target_unit = get_unit_at(target_q, target_r);

	// Check for attack (can happen before OR after movement)
	if (target_unit != noone && target_unit.team != unit.team && !unit.has_acted) {
	    // Check if target is in attack range from current position
	    var can_attack = false;
	    
	    // Get all six adjacent hexes
	    with (obj_grid_manager) {
	        var directions = get_hex_directions(unit.grid_y);
	        for (var i = 0; i < array_length(directions); i++) {
	            var check_q = unit.grid_x + directions[i][0];
	            var check_r = unit.grid_y + directions[i][1];
	            
	            if (check_q == target_q && check_r == target_r) {
	                can_attack = true;
	                break;
	            }
	        }
	    }
	    
	    if (can_attack) {
	        execute_attack(unit, target_unit);
	        unit.has_acted = true;
        
	        // After attacking, if unit hasn't moved yet, show movement options
	        if (!unit.has_moved) {
	            scr_clear_highlights();
	            calculate_movement_range(unit);
	            obj_grid_manager.highlight_grid[unit.grid_x][unit.grid_y] = 3; // Keep unit highlighted
	            return; // Keep unit selected for potential movement
	        } else {
	            // Unit has both moved and acted, deselect
	            scr_unit_deselect(unit);
	            return;
	        }
	    }
	}

	// Check for movement (can happen before OR after attacking)
	if (target_unit == noone && !unit.has_moved) {
	    if (obj_grid_manager.highlight_grid[target_q][target_r] == 1) {
	        // Set up movement path
	        ds_list_clear(unit.movement_path);
	        
	        // Start with target position
	        var current_q = target_q;
	        var current_r = target_r;
	        ds_list_add(unit.movement_path, [current_q, current_r]);
	        
	        // Trace back through movement grid to build path
	        while (current_q != unit.grid_x || current_r != unit.grid_y) {
	            var found_next = false;
	            var current_value = obj_grid_manager.movement_grid[current_q][current_r];
	            
	            with (obj_grid_manager) {
	                var directions = get_hex_directions(current_r);
	                for (var i = 0; i < array_length(directions); i++) {
	                    var check_q = current_q + directions[i][0];
	                    var check_r = current_r + directions[i][1];
	                    
	                    if (is_valid_position(check_q, check_r)) {
	                        // Look for a neighbor with exactly one less movement point
	                        if (movement_grid[check_q][check_r] == current_value - 1) {
	                            current_q = check_q;
	                            current_r = check_r;
	                            ds_list_insert(unit.movement_path, 0, [current_q, current_r]);
	                            found_next = true;
	                            break;
	                        }
	                    }
	                }
	            }
	            
	            // If we can't find the next step, something went wrong
	            if (!found_next) {
	                show_debug_message("Path finding failed! Current value: " + string(current_value));
	                show_debug_message("Current position: " + string(current_q) + "," + string(current_r));
	                ds_list_clear(unit.movement_path);
	                return;
	            }
	        } // End of path building loop
	        
	        // Start movement animation
	        unit.is_moving = true;
	        unit.current_path_position = 0;
	        unit.move_progress = 0;
	        unit.has_moved = true;
	        remove_unit_from_grid(unit);
	        
	        // After moving, if unit hasn't acted yet, show attack options
	        if (!unit.has_acted) {
	            scr_clear_highlights();
	            calculate_attack_range(unit);
	            obj_grid_manager.highlight_grid[target_q][target_r] = 3; // Keep unit highlighted
	            return; // Keep unit selected for potential attack
	        } else {
	            // Unit has both moved and acted, deselect
	            scr_unit_deselect(unit);
	            return;
	        }
	    }
	}

	// If clicking on empty space with no valid action, deselect
	scr_unit_deselect(unit);
}