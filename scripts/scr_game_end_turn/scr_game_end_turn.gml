// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_game_end_turn(){
	/// End current turn and switch teams
	with (obj_game_manager) {
	    // Clear any pending actions and reset state
	    ds_queue_clear(action_queue);
	    current_action = noone;
	    action_in_progress = false;
	    animation_in_progress = false;
	    
	    // Cancel any active targeting
	    cancel_targeting();
	    
	    // Reset all units of current team
	    var units = (current_team == 0) ? player_units : enemy_units;
	    for (var i = 0; i < array_length(units); i++) {
	        units[i].has_moved = false;
	        units[i].has_acted = false;
	        scr_unit_deselect(units[i]);
	    }

	    // Switch teams
	    current_team = 1 - current_team;
	    if (current_team == 0) {
	        turn_number++;
	    }

	    // Set appropriate game state and handle AI
	    if (current_team == 1) {
	        game_state = GameState.AI_THINKING;
	        alarm[0] = 60; // Trigger AI after 1 second
	    } else {
	        game_state = GameState.WAITING_FOR_INPUT;
	    }
	    
	    // Update old_game_state for compatibility
	    old_game_state = "playing";
	}
}