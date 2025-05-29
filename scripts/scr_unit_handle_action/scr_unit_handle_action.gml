// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function scr_unit_handle_action(unit, target_q, target_r){
	/// Handle unit action based on target position
	/// @param {Id.Instance} unit - The unit performing the action
	/// @param {Real} target_q - Target hex Q coordinate
	/// @param {Real} target_r - Target hex R coordinate
	if (!is_valid_position(target_q, target_r)) {
	    show_debug_message("[ACTION] Invalid position selected: [" + string(target_q) + "," + string(target_r) + "]");
	    scr_unit_deselect(unit);
	    return;
	}

	var target_unit = get_unit_at(target_q, target_r);
	show_debug_message("[ACTION] " + unit.unit_type + " at [" + string(unit.grid_x) + "," + string(unit.grid_y) + "] attempting action at [" + string(target_q) + "," + string(target_r) + "]");

	// Check for attack (can happen before OR after movement)
	if (target_unit != noone && target_unit.team != unit.team && !unit.has_acted) {
	    // Check if target is in attack range from current position
	    var can_attack = false;
	    
	    // Calculate distance to target
	    var distance = scr_hex_distance(unit.grid_x, unit.grid_y, target_q, target_r);
	    show_debug_message("[COMBAT] Checking attack range. Distance to target: " + string(distance) + ", Unit's attack range: " + string(unit.attack_range));
	    
	    // Use the same flood fill algorithm as attack range visualization
	    if (is_target_in_attack_range(unit, target_q, target_r)) {
	        can_attack = true;
	        show_debug_message("[COMBAT] Target is within attack range!");
	    }
	    
	    if (can_attack) {
	        show_debug_message("[COMBAT] " + unit.unit_type + " attacking " + target_unit.unit_type + " at [" + string(target_q) + "," + string(target_r) + "]");
	        execute_attack(unit, target_unit);
	        unit.has_acted = true;
        
	        // After attacking, if unit hasn't moved yet, show movement options
	        if (!unit.has_moved) {
	            show_debug_message("[ACTION] Unit can still move after attack. Showing movement options.");
	            scr_clear_highlights();
	            calculate_movement_range(unit);
	            obj_grid_manager.highlight_grid[unit.grid_x][unit.grid_y] = 3; // Keep unit highlighted
	            return; // Keep unit selected for potential movement
	        } else {
	            // Unit has both moved and acted, deselect
	            show_debug_message("[ACTION] Unit has completed all actions. Deselecting.");
	            scr_unit_deselect(unit);
	            return;
	        }
	    } else {
	        show_debug_message("[COMBAT] Target is out of attack range.");
	    }
	}

	// Check for movement (can happen before OR after attacking)
	if (target_unit == noone && !unit.has_moved) {
	    if (obj_grid_manager.highlight_grid[target_q][target_r] == 1) {
	        show_debug_message("[MOVEMENT] " + unit.unit_type + " starting movement to [" + string(target_q) + "," + string(target_r) + "]");
	        
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
	                show_debug_message("[ERROR] Path finding failed at [" + string(current_q) + "," + string(current_r) + "]");
	                ds_list_clear(unit.movement_path);
	                return;
	            }
	        }
	        
	        show_debug_message("[MOVEMENT] Path found with " + string(ds_list_size(unit.movement_path)) + " steps");
	        
	        // Start movement animation
	        unit.is_moving = true;
	        unit.current_path_position = 0;
	        unit.move_progress = 0;
	        unit.has_moved = true;
	        remove_unit_from_grid(unit);
	        
	        // After moving, if unit hasn't acted yet, show attack options
	        if (!unit.has_acted) {
	            show_debug_message("[ACTION] Unit can still attack after movement. Showing attack options.");
	            scr_clear_highlights();
	            calculate_attack_range(unit);
	            obj_grid_manager.highlight_grid[target_q][target_r] = 3; // Keep unit highlighted
	            return; // Keep unit selected for potential attack
	        } else {
	            // Unit has both moved and acted, deselect
	            show_debug_message("[ACTION] Unit has completed all actions. Deselecting.");
	            scr_unit_deselect(unit);
	            return;
	        }
	    } else {
	        show_debug_message("[MOVEMENT] Invalid movement target - not in movement range");
	    }
	}

	// If clicking on empty space with no valid action, deselect
	show_debug_message("[ACTION] No valid action found. Deselecting unit.");
	scr_unit_deselect(unit);
}