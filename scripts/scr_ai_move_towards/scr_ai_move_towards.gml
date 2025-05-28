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
	            if (movement_grid[q][r] > 0 && get_unit_at(q, r) == noone) {
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
	    remove_unit_from_grid(unit);
	    place_unit_on_grid(unit, best_pos[0], best_pos[1]);
	    unit.has_moved = true;
	    show_debug_message("AI unit moved to " + string(best_pos[0]) + "," + string(best_pos[1]) + 
	                      " (Can attack after move: " + string(can_attack_after_move) + ")");
	} else {
	    show_debug_message("AI unit couldn't find better position than current");
	}

	scr_clear_highlights();
}