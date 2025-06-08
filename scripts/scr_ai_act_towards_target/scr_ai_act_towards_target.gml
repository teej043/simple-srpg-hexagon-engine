// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_ai_act_towards_target(unit, target){
	/// AI unit acts towards target
	/// @param {Id.Instance} unit - The AI unit
	/// @param {Id.Instance} target - The target unit
	
	// If target no longer exists, find a new one
	if (!instance_exists(target)) {
		target = scr_ai_find_nearest_enemy(unit);
		if (target == noone) {
			// No targets left, just end turn
			scr_unit_wait(unit);
			return;
		}
	}
	
	// First check if we can attack any player unit from current position
	var can_attack = false;
	var best_attack_target = noone;
	var lowest_hp = 999999;
	
	with (obj_game_manager) {
		// Check all player units for possible immediate attacks
		for (var p = 0; p < array_length(player_units); p++) {
			var potential_target = player_units[p];
			if (!instance_exists(potential_target)) continue;
			
			// Use the same flood fill algorithm as attack range visualization
			if (is_target_in_attack_range(unit, potential_target.grid_x, potential_target.grid_y)) {
				can_attack = true;
				// Update best target if this one has lower HP
				if (potential_target.current_hp < lowest_hp) {
					lowest_hp = potential_target.current_hp;
					best_attack_target = potential_target;
				}
			}
		}
	}

	// If we can attack any target and haven't acted yet, do it immediately
	if (can_attack && !unit.has_acted && instance_exists(best_attack_target)) {
		if (DEBUG) {
			show_debug_message("AI: Attacking target from position (" + string(unit.grid_x) + "," + string(unit.grid_y) + ")");
		}
		execute_attack(unit, best_attack_target);
		unit.has_acted = true;
		
		// After attacking, if we haven't moved, consider moving to a new target
		if (!unit.has_moved) {
			// Find best target considering movement range and HP
			var best_new_target = noone;
			var best_distance = 999999;
			lowest_hp = 999999;
			
			with (obj_game_manager) {
				for (var p = 0; p < array_length(player_units); p++) {
					var potential_target = player_units[p];
					if (!instance_exists(potential_target)) continue;
					if (potential_target == best_attack_target) continue; // Skip the unit we just attacked
					
					var distance = scr_hex_distance(unit.grid_x, unit.grid_y, potential_target.grid_x, potential_target.grid_y);
					
					// Prioritize units that are:
					// 1. Within movement + attack range
					// 2. Have lower HP
					if (distance <= unit.movement_range + unit.attack_range) {
						if (potential_target.current_hp < lowest_hp || 
						   (potential_target.current_hp == lowest_hp && distance < best_distance)) {
							lowest_hp = potential_target.current_hp;
							best_distance = distance;
							best_new_target = potential_target;
						}
					}
				}
			}
			
			if (best_new_target != noone && instance_exists(best_new_target)) {
				if (DEBUG) {
					show_debug_message("AI: Moving towards new target (HP: " + string(best_new_target.current_hp) + ", Distance: " + string(best_distance) + ")");
				}
				scr_ai_move_towards(unit, best_new_target);
				
				// Store target info for post-movement check
				with (obj_game_manager) {
					ai_pending_unit = unit;
					ai_pending_target = best_new_target;
					// Set alarm to check for attack after movement animation
					alarm[1] = 1;
				}
				return;
			}
		}
		
		// If we can't or don't need to move to a new target, end turn
		if (unit.has_moved) {
			scr_unit_deselect(unit);
		}
		return;
	}
	
	// If we can't attack immediately but haven't moved, find best target considering movement
	if (!unit.has_moved) {
		// Find best target considering movement range and HP
		var best_move_target = target; // Default to original target
		var best_distance = scr_hex_distance(unit.grid_x, unit.grid_y, target.grid_x, target.grid_y);
		lowest_hp = target.current_hp;
		
		with (obj_game_manager) {
			for (var p = 0; p < array_length(player_units); p++) {
				var potential_target = player_units[p];
				if (!instance_exists(potential_target)) continue;
				
				var distance = scr_hex_distance(unit.grid_x, unit.grid_y, potential_target.grid_x, potential_target.grid_y);
				
				// Prioritize units that are:
				// 1. Within movement + attack range
				// 2. Have lower HP
				// 3. Are closer if HP is equal
				if (distance <= unit.movement_range + unit.attack_range) {
					if (potential_target.current_hp < lowest_hp || 
					   (potential_target.current_hp == lowest_hp && distance < best_distance)) {
						lowest_hp = potential_target.current_hp;
						best_distance = distance;
						best_move_target = potential_target;
					}
				}
			}
		}
		
		if (instance_exists(best_move_target)) {
			if (DEBUG) {
				show_debug_message("AI: Moving towards best target (HP: " + string(best_move_target.current_hp) + ", Distance: " + string(best_distance) + ")");
			}
			scr_ai_move_towards(unit, best_move_target);
			
			// Store target info for post-movement check
			with (obj_game_manager) {
				ai_pending_unit = unit;
				ai_pending_target = best_move_target;
				// Set alarm to check for attack after movement animation
				alarm[1] = 1;
			}
			return;
		} else {
			// No valid targets left, just end turn
			scr_unit_wait(unit);
			return;
		}
	}
	
	// If we can't do anything else, wait
	if (!unit.has_moved || !unit.has_acted) {
		if (DEBUG) {
			show_debug_message("AI: Waiting (no valid actions)");
		}
		scr_unit_wait(unit);
	}
}