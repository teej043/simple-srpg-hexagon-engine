// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function execute_attack(attacker, defender){
	/// Execute combat between two units
	/// @param {Id.Instance} attacker - The attacking unit
	/// @param {Id.Instance} defender - The defending unit
	
	var distance = scr_hex_distance(attacker.grid_x, attacker.grid_y, defender.grid_x, defender.grid_y);
	
	if (DEBUG) {
		show_debug_message("\n=== COMBAT START ===");
		show_debug_message("[COMBAT] " + attacker.unit_type + " at [" + string(attacker.grid_x) + "," + string(attacker.grid_y) + 
						  "] (ATK:" + string(attacker.attack_power) + ", Range:" + string(attacker.attack_range) + 
						  ") attacking " + defender.unit_type + " at [" + string(defender.grid_x) + "," + string(defender.grid_y) + 
						  "] (DEF:" + string(defender.defense) + ", HP:" + string(defender.current_hp) + ")");
		show_debug_message("[COMBAT] Distance between units: " + string(distance));
	}
	
	// Use the same flood fill algorithm as attack range visualization
	if (!is_target_in_attack_range(attacker, defender.grid_x, defender.grid_y)) {
		if (DEBUG) {
			show_debug_message("[COMBAT ERROR] Target is beyond attack range! Distance: " + string(distance) + 
							  ", Attack range: " + string(attacker.attack_range));
		}
		return;
	}
	
	var damage = max(1, attacker.attack_power - defender.defense);
	defender.current_hp -= damage;
	
	if (DEBUG) {
		show_debug_message("[COMBAT] Damage dealt: " + string(damage) + " (ATK " + string(attacker.attack_power) + 
						  " - DEF " + string(defender.defense) + ")");
		show_debug_message("[COMBAT] " + defender.unit_type + " HP: " + string(defender.current_hp + damage) + 
						  " -> " + string(defender.current_hp));
	}

	// Check if defender is defeated
	if (defender.current_hp <= 0) {
		if (DEBUG) {
			show_debug_message("[COMBAT] " + defender.unit_type + " was defeated!");
		}
		
		with (obj_game_manager) {
			// Remove from appropriate team list
			if (defender.team == 0) {
				for (var i = 0; i < array_length(player_units); i++) {
					if (player_units[i] == defender) {
						array_delete(player_units, i, 1);
						if (DEBUG) {
							show_debug_message("[COMBAT] Removed unit from player team");
						}
						break;
					}
				}
			} else {
				for (var i = 0; i < array_length(enemy_units); i++) {
					if (enemy_units[i] == defender) {
						array_delete(enemy_units, i, 1);
						if (DEBUG) {
							show_debug_message("[COMBAT] Removed unit from enemy team");
						}
						break;
					}
				}
			}
		}
	
		remove_unit_from_grid(defender);
		instance_destroy(defender);
	}

	attacker.has_acted = true;
	if (DEBUG) {
		show_debug_message("=== COMBAT END ===\n");
	}
}