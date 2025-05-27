// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function remove_unit_from_grid(unit){
	/// Remove a unit from the grid
	/// @param {Id.Instance} unit - The unit to remove
	with (obj_grid_manager) {
	    if (unit.grid_x >= 0 && unit.grid_x < grid_width && 
	        unit.grid_y >= 0 && unit.grid_y < grid_height) {
	        if (grid[unit.grid_x][unit.grid_y] == unit) {
	            grid[unit.grid_x][unit.grid_y] = noone;
	        }
	    }
	}
}