// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_unit_update_pixel_position(unit){
	/// Update pixel position based on grid coordinates
	/// @param {Id.Instance} unit - The unit instance
	// Only update position if grid manager exists and unit has valid grid position
	if (instance_exists(obj_grid_manager) && unit.grid_x >= 0 && unit.grid_y >= 0) {
	    var pos = hex_to_pixel(unit.grid_x, unit.grid_y);
    
	    // Only update if there's actually a difference (prevent floating point drift)
	    var distance_diff = point_distance(unit.x, unit.y, pos[0], pos[1]);
	    if (distance_diff > 0.5) {  // Only update if more than 0.5 pixels different
	        show_debug_message("POSITION UPDATE: Unit " + string(unit.id) + " moving " + 
	                          string(distance_diff) + " pixels from (" + string(unit.x) + "," + string(unit.y) + 
	                          ") to (" + string(pos[0]) + "," + string(pos[1]) + ")");
        
	        unit.x = pos[0];
	        unit.y = pos[1];
	    }
	}
}