// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function get_hex_neighbors(q, r){
	/// Get neighboring hex coordinates
	/// @param {Real} q - Hex Q coordinate
	/// @param {Real} r - Hex R coordinate
	/// @return {Array} - Array of [q, r] neighbor coordinates
	with (obj_grid_manager) {
	    var neighbors = [];
	    // Get the correct hex directions based on the row
	    var directions = get_hex_directions(r);

	    for (var i = 0; i < array_length(directions); i++) {
	        var nq = q + directions[i][0];
	        var nr = r + directions[i][1];
	        array_push(neighbors, [nq, nr]);
	    }

	    return neighbors;
	}
	return [];
}