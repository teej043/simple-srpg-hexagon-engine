// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_game_simple_ai(){
	/// Simple AI for enemy units
	with (obj_game_manager) {
	    if (current_team != 1) return;
    
	    // Find first available enemy unit
	    for (var i = 0; i < array_length(enemy_units); i++) {
	        var unit = enemy_units[i];
	        if (!unit.has_acted) {
	            // Select the unit before acting
	            scr_unit_select(unit);
	            
	            // Simple AI: move towards nearest player unit or attack if possible
	            var nearest_player = scr_ai_find_nearest_enemy(unit);
	            if (nearest_player != noone) {
	                scr_ai_act_towards_target(unit, nearest_player);
	            } else {
	                scr_unit_wait(unit);
	            }
	            break;
	        }
	    }
    
	    // Check if all enemy units have acted
	    var all_acted = true;
	    for (var i = 0; i < array_length(enemy_units); i++) {
	        if (!enemy_units[i].has_acted) {
	            all_acted = false;
	            break;
	        }
	    }
    
	    if (all_acted) {
	        scr_game_end_turn();
	    } else {
	        alarm[0] = 30; // Continue AI after short delay
	    }
	}
}