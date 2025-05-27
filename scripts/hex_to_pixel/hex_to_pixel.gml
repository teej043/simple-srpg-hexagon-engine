// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// Convert hex coordinates to pixel coordinates
/// @param {Real} q - Hex Q coordinate  
/// @param {Real} r - Hex R coordinate
/// @return {Array} - [x, y] pixel coordinates
function hex_to_pixel(q, r){
	with (obj_grid_manager) {
		// Convert axial coordinates to pixel coordinates
		var x_pos = grid_offset_x + hex_size * (3/2 * q);
		var y_pos = grid_offset_y + hex_size * (sqrt(3) * (r + q/2));
		
		// Add a slight offset based on terrain height for visual depth
		if (is_valid_position(q, r)) {
			y_pos -= terrain_height[q][r] * 0.5; // Adjust Y position based on height
		}
		
		return [x_pos, y_pos];
	}
	// Fallback if grid manager doesn't exist
	return [0, 0];
}