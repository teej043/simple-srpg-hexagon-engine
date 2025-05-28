// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_ai_act_towards_target(unit, target){
	/// AI unit acts towards target
	/// @param {Id.Instance} unit - The AI unit
	/// @param {Id.Instance} target - The target unit
	
	// First check if we can attack from current position
	var can_attack = false;
	
	with (obj_grid_manager) {
		var directions = get_hex_directions(unit.grid_y);
		for (var i = 0; i < array_length(directions); i++) {
			var check_q = unit.grid_x + directions[i][0];
			var check_r = unit.grid_y + directions[i][1];
			
			if (target.grid_x == check_q && target.grid_y == check_r) {
				can_attack = true;
				break;
			}
		}
	}

	// If we can attack and haven't acted yet, do it immediately
	if (can_attack && !unit.has_acted) {
		show_debug_message("AI: Attacking target from position (" + string(unit.grid_x) + "," + string(unit.grid_y) + ")");
		execute_attack(unit, target);
		return;
	}
	
	// If we can't attack but haven't moved, try to move closer
	if (!unit.has_moved) {
		show_debug_message("AI: Moving towards target");
		scr_ai_move_towards(unit, target);
		
		// After moving, check if we can now attack
		can_attack = false;
		with (obj_grid_manager) {
			var directions = get_hex_directions(unit.grid_y);
			for (var i = 0; i < array_length(directions); i++) {
				var check_q = unit.grid_x + directions[i][0];
				var check_r = unit.grid_y + directions[i][1];
				
				if (target.grid_x == check_q && target.grid_y == check_r) {
					can_attack = true;
					break;
				}
			}
		}
		
		// If we can now attack after moving, do it
		if (can_attack && !unit.has_acted) {
			show_debug_message("AI: Attacking target after moving");
			execute_attack(unit, target);
			return;
		}
	}
	
	// If we can't do anything else, wait
	if (!unit.has_moved || !unit.has_acted) {
		show_debug_message("AI: Waiting (no valid actions)");
		scr_unit_wait(unit);
	}
}