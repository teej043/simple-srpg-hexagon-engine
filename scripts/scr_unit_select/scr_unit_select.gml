// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_unit_select(unit){
	/// Select this unit
	/// @param {Id.Instance} unit - The unit instance to select
	
	if (DEBUG) {
		show_debug_message("[SELECT] Selecting unit at [" + string(unit.grid_x) + "," + string(unit.grid_y) + "]");
	}
	
	// Deselect other units
	with (obj_unit) {
	    is_selected = false;
	}

	unit.is_selected = true;
	obj_game_manager.selected_unit = unit;

	// Show available actions based on unit state
	if (DEBUG) {
		show_debug_message("[SELECT] Clearing highlights");
	}
	scr_clear_highlights();

	// Show movement range if unit hasn't moved
	if (!unit.has_moved) {
		if (DEBUG) {
			show_debug_message("[SELECT] Calculating movement range");
		}
	    calculate_movement_range(unit);
	}

	// Show attack range if unit hasn't acted (can attack from current position)
	// Always show attack range when first selecting a unit, even if they haven't moved yet
	if (!unit.has_acted) {
		if (DEBUG) {
			show_debug_message("[SELECT] Calculating attack range");
		}
	    calculate_attack_range(unit);
	}

	// Highlight the selected unit's current position
	obj_grid_manager.highlight_grid[unit.grid_x][unit.grid_y] = 3; // Green highlight for selected unit
	
	// No longer need surface update tracking for sprite-based rendering
	
	if (DEBUG) {
		show_debug_message("[SELECT] Unit selection complete");
	}
}