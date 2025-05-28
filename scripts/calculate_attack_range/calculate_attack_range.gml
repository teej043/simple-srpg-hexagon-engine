// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function calculate_attack_range(unit){
	/// Calculate valid attack positions for a unit
	/// @param {Id.Instance} unit - The unit to calculate attack range for
	with (obj_grid_manager) {
	    // Get the correct hex directions based on the unit's row
	    var directions = get_hex_directions(unit.grid_y);
	    
	    // Check all six adjacent hexes
	    for (var i = 0; i < array_length(directions); i++) {
	        var nq = unit.grid_x + directions[i][0];
	        var nr = unit.grid_y + directions[i][1];
	        
	        if (is_valid_position(nq, nr)) {
	            var target = get_unit_at(nq, nr);
	            if (target != noone && target.team != unit.team) {
	                highlight_grid[nq][nr] = 2; // Red highlight for attack
	            }
	        }
	    }
	}
}

