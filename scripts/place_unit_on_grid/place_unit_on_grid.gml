// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function place_unit_on_grid(unit, q, r){
	/// Place a unit on the grid
	/// @param {Id.Instance} unit - The unit to place
	/// @param {Real} q - Hex Q coordinate
	/// @param {Real} r - Hex R coordinate
	/// @return {Bool} - Success/failure
	with (obj_grid_manager) {
	    if (q >= 0 && q < grid_width && r >= 0 && r < grid_height) {
	        if (grid[q][r] == noone) {
	            grid[q][r] = unit;
	            unit.grid_x = q;
	            unit.grid_y = r;
	            scr_unit_update_pixel_position(unit);
	            return true;
	        }
	    }
	}
	return false;
}