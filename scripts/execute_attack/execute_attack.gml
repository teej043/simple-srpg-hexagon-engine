// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function execute_attack(attacker, defender){
	/// Execute combat between two units
	/// @param {Id.Instance} attacker - The attacking unit
	/// @param {Id.Instance} defender - The defending unit
	var damage = max(1, attacker.attack_power - defender.defense);
	defender.current_hp -= damage;

	show_debug_message("Attack: " + string(damage) + " damage dealt. Defender HP: " + string(defender.current_hp));

	// Check if defender is defeated
	if (defender.current_hp <= 0) {
	    with (obj_game_manager) {
	        // Remove from appropriate team list
	        if (defender.team == 0) {
	            for (var i = 0; i < array_length(player_units); i++) {
	                if (player_units[i] == defender) {
	                    array_delete(player_units, i, 1);
	                    break;
	                }
	            }
	        } else {
	            for (var i = 0; i < array_length(enemy_units); i++) {
	                if (enemy_units[i] == defender) {
	                    array_delete(enemy_units, i, 1);
	                    break;
	                }
	            }
	        }
	    }
    
	    remove_unit_from_grid(defender);
	    instance_destroy(defender);
	}

	attacker.has_acted = true;
}