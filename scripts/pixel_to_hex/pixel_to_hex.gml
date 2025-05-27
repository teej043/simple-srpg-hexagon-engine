// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pixel_to_hex(px, py){
	/// Convert pixel coordinates to hex coordinates
	/// @param {Real} px - Pixel X coordinate
	/// @param {Real} py - Pixel Y coordinate
	/// @return {Array} - [q, r] hex coordinates
	with (obj_grid_manager) {
	    // Corrected pixel-to-hex conversion for pointy-top hexagons
	    var xx = (px - grid_offset_x) / hex_size;
	    var yy = (py - grid_offset_y) / hex_size;

	    var q = (2/3) * xx;
	    var r = yy/sqrt(3) - q/2;

	    return hex_round(q, r);
	}
	// Fallback if grid manager doesn't exist
	return [0, 0];
}