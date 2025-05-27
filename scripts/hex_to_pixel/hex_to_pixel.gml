// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function hex_to_pixel(q, r){
	/// Convert hex coordinates to pixel coordinates
	/// @param {Real} q - Hex Q coordinate  
	/// @param {Real} r - Hex R coordinate
	/// @return {Array} - [x, y] pixel coordinates
	with (obj_grid_manager) {
	    // Simplified hex-to-pixel conversion - round to avoid floating point drift
	    var x_pos = round(grid_offset_x + hex_size * (3/2 * q));
	    var y_pos = round(grid_offset_y + hex_size * (sqrt(3) * (r + q/2)));
    
	    return [x_pos, y_pos];
	}
	// Fallback if grid manager doesn't exist
	return [0, 0];
}