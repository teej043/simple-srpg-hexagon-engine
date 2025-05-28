// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pixel_to_hex(px, py){
	/// Convert pixel coordinates to hex coordinates for flat-topped hexagons
	/// @param {Real} px - Pixel X coordinate
	/// @param {Real} py - Pixel Y coordinate
	/// @return {Array} - [q, r] hex coordinates
	with (obj_grid_manager) {
	    // First find approximate row (r)
	    var r = (py - grid_offset_y) / (hex_size * 1.5);
	    var r_rounded = round(r);
	    
	    // Adjust x position based on row offset
	    var x_adjusted = px - grid_offset_x - ((r_rounded % 2) * hex_width * 0.5);
	    var q = x_adjusted / hex_width;
	    
	    return hex_round(q, r);
	}
	// Fallback if grid manager doesn't exist
	return [0, 0];
}