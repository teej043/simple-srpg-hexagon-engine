// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_ai_act_towards_target(unit, target){
	/// AI unit acts towards target
	/// @param {Id.Instance} unit - The AI unit
	/// @param {Id.Instance} target - The target unit
	// Check if target is in attack range
	var neighbors = get_hex_neighbors(unit.grid_x, unit.grid_y);
	var can_attack = false;

	for (var i = 0; i < array_length(neighbors); i++) {
	    var nq = neighbors[i][0];
	    var nr = neighbors[i][1];
	    if (target.grid_x == nq && target.grid_y == nr) {
	        can_attack = true;
	        break;
	    }
	}

	if (can_attack && !unit.has_acted) {
	    // Attack the target
	    execute_attack(unit, target);
	} else if (!unit.has_moved) {
	    // Move towards target
	    scr_ai_move_towards(unit, target);
	} else {
	    // Wait
	    scr_unit_wait(unit);
	}
}