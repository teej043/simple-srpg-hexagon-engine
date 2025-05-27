// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function is_valid_position(q, r){
	/// Check if position is within grid bounds
	/// @param {Real} q - Hex Q coordinate
	/// @param {Real} r - Hex R coordinate
	/// @return {Bool} - True if valid position
	with (obj_grid_manager) {
	    return (q >= 0 && q < grid_width && r >= 0 && r < grid_height);
	}
	return false;
}