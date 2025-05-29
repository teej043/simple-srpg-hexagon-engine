// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_game_simple_ai(){
	/// Simple AI for enemy units (now using action queue system)
	with (obj_game_manager) {
	    if (current_team != 1) return;
	    
	    // Set game state to AI thinking
	    game_state = GameState.AI_THINKING;
    
	    // Find first available enemy unit
	    for (var i = 0; i < array_length(enemy_units); i++) {
	        var unit = enemy_units[i];
	        if (!unit.has_acted) {
	            // Select the unit before acting
	            scr_unit_select(unit);
	            
	            // Simple AI: move towards nearest player unit or attack if possible
	            var nearest_player = scr_ai_find_nearest_enemy(unit);
	            if (nearest_player != noone) {
	                // Create AI action and queue it
	                var ai_action = scr_ai_create_action(unit, nearest_player);
	                if (ai_action != noone) {
	                    queue_action(ai_action);
	                    process_next_action();
	                    return; // Wait for this action to complete
	                } else {
	                    // No valid action, wait
	                    var wait_action = create_wait_action(unit);
	                    queue_action(wait_action);
	                    process_next_action();
	                    return;
	                }
	            } else {
	                // No targets, wait
	                var wait_action = create_wait_action(unit);
	                queue_action(wait_action);
	                process_next_action();
	                return;
	            }
	        }
	    }
    
	    // If we reach here, all enemy units have acted
	    scr_game_end_turn();
	}
}

/// Create appropriate AI action based on unit and target
/// @param {Id.Instance} unit - AI unit
/// @param {Id.Instance} target - Target player unit
/// @return {Struct} - Action data or noone if no valid action
function scr_ai_create_action(unit, target) {
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

    // If we can attack any target and haven't acted yet, create attack action
    if (can_attack && !unit.has_acted && instance_exists(best_attack_target)) {
        show_debug_message("AI: Creating attack action from position (" + string(unit.grid_x) + "," + string(unit.grid_y) + ")");
        return create_attack_action(unit, best_attack_target);
    }
    
    // If we can't attack immediately but haven't moved, create move action
    if (!unit.has_moved) {
        var best_move_pos = scr_ai_find_best_move_position(unit, target);
        if (best_move_pos != noone) {
            show_debug_message("AI: Creating move action to (" + string(best_move_pos[0]) + "," + string(best_move_pos[1]) + ")");
            return create_move_action(unit, best_move_pos[0], best_move_pos[1]);
        }
    }
    
    // No valid action found
    return noone;
}

/// Find best movement position for AI unit
/// @param {Id.Instance} unit - AI unit
/// @param {Id.Instance} target - Target player unit
/// @return {Array} - [q, r] position or noone if none found
function scr_ai_find_best_move_position(unit, target) {
    calculate_movement_range(unit);

    var best_pos = noone;
    var best_distance = 999999;
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

    return best_pos;
}