// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function get_unit_at(q, r){
	/// Get unit at grid position
	/// @param {Real} q - Hex Q coordinate
	/// @param {Real} r - Hex R coordinate
	/// @return {Id.Instance} - Unit instance or noone
	with (obj_grid_manager) {
	    if (q >= 0 && q < grid_width && r >= 0 && r < grid_height) {
	        return grid[q][r];
	    }
	}
	return noone;
}