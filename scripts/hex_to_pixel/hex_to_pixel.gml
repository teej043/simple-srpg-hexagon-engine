// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function hex_to_pixel(q, r){
	/// Convert hex coordinates to pixel coordinates for flat-topped hexagons
	/// @param {Real} q - Hex Q coordinate  
	/// @param {Real} r - Hex R coordinate
	/// @return {Array} - [x, y] pixel coordinates
	with (obj_grid_manager) {
	    // Flat-topped hex-to-pixel conversion with offset for even rows
	    var x_pos = round(grid_offset_x + hex_width * q + ((r % 2) * hex_width * 0.5));
	    var y_pos = round(grid_offset_y + hex_size * (r * 1.5));
    
	    return [x_pos, y_pos];
	}
	// Fallback if grid manager doesn't exist
	return [0, 0];
}