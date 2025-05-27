// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_ai_find_nearest_enemy(unit){
	/// Find nearest enemy unit
	/// @param {Id.Instance} unit - The AI unit
	/// @return {Id.Instance} - Nearest enemy unit or noone
	var nearest = noone;
	var min_distance = 999;

	var targets = (unit.team == 0) ? obj_game_manager.enemy_units : obj_game_manager.player_units;

	for (var i = 0; i < array_length(targets); i++) {
	    var target = targets[i];
	    var distance = scr_hex_distance(unit.grid_x, unit.grid_y, target.grid_x, target.grid_y);
	    if (distance < min_distance) {
	        min_distance = distance;
	        nearest = target;
	    }
	}

	return nearest;
}