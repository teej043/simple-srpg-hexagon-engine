// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_game_end_turn(){
	/// End current turn and switch teams
	with (obj_game_manager) {
	    // Reset all units of current team
	    var units = (current_team == 0) ? player_units : enemy_units;
	    for (var i = 0; i < array_length(units); i++) {
	        units[i].has_moved = false;
	        units[i].has_acted = false;
	        units[i].can_reverse_movement = false; // Reset movement reversal capability
	        units[i].original_grid_x = units[i].grid_x; // Set current position as new original
	        units[i].original_grid_y = units[i].grid_y;
	        scr_unit_deselect(units[i]);
	    }

	    // Switch teams
	    current_team = 1 - current_team;
	    if (current_team == 0) {
	        turn_number++;
	    }

	    // Simple AI for enemy turn
	    if (current_team == 1) {
	        alarm[0] = 60; // Trigger AI after 1 second
	    }
	}
}