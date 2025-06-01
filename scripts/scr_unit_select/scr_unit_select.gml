// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_unit_select(unit){
	/// Select this unit
	/// @param {Id.Instance} unit - The unit instance to select
	
	show_debug_message("[UNIT_SELECT] Selecting unit: " + unit.unit_type + " at [" + string(unit.grid_x) + "," + string(unit.grid_y) + "]");
	show_debug_message("[UNIT_SELECT] Unit state - has_moved: " + string(unit.has_moved) + ", has_acted: " + string(unit.has_acted));
	
	// Deselect other units
	with (obj_unit) {
	    is_selected = false;
	}

	unit.is_selected = true;
	obj_game_manager.selected_unit = unit;

	// Clear all highlights first, then show available actions based on unit state
	scr_clear_highlights();

	// Show movement range if unit hasn't moved
	if (!unit.has_moved) {
		show_debug_message("[UNIT_SELECT] Calculating movement range");
	    calculate_movement_range(unit);
	}

	// Show attack range if unit hasn't acted (can attack from current position)
	// Always show attack range when first selecting a unit, even if they haven't moved yet
	if (!unit.has_acted) {
		show_debug_message("[UNIT_SELECT] Calculating attack range");
	    calculate_attack_range(unit);
	}

	// Highlight current unit position (this should be done last to ensure it's visible)
	obj_grid_manager.highlight_grid[unit.grid_x][unit.grid_y] = 3; // Green highlight for selected unit
	
	show_debug_message("[UNIT_SELECT] Selection complete");
}