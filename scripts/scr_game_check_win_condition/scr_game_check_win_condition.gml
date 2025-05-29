// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_game_check_win_condition(){
	/// Check if game is over
	/// @return {String} - Game state: "playing", "player_wins", "enemy_wins"
	with (obj_game_manager) {
	    if (array_length(player_units) == 0) {
	        old_game_state = "enemy_wins";
	        game_state = GameState.GAME_OVER;
	        return "enemy_wins";
	    } else if (array_length(enemy_units) == 0) {
	        old_game_state = "player_wins";
	        game_state = GameState.GAME_OVER;
	        return "player_wins";
	    }
	    old_game_state = "playing";
	    return "playing";
	}
}