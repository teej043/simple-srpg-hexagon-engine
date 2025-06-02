// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_unit_update_pixel_position(unit){
	/// Update pixel position based on grid coordinates
	/// @param {Id.Instance} unit - The unit instance
	// Only update position if grid manager exists and unit has valid grid position
	if (instance_exists(obj_grid_manager) && unit.grid_x >= 0 && unit.grid_y >= 0) {
	    var pos = hex_to_pixel(unit.grid_x, unit.grid_y);
    
	    // Update both actual and instance positions
	    unit.x = pos[0];
	    unit.y = pos[1];
	    unit.actual_x = pos[0];
	    unit.actual_y = pos[1];
	    unit.z = 0; // Set Z coordinate to ground level
	    
	    show_debug_message("POSITION UPDATE: Unit " + string(unit.id) + 
	                      " moved to grid (" + string(unit.grid_x) + "," + string(unit.grid_y) + 
	                      ") at pixel position (" + string(pos[0]) + "," + string(pos[1]) + ")");
	}
}