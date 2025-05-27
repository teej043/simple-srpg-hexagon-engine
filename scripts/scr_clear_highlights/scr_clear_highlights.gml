// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_clear_highlights(){
	/// Clear all grid highlights
	with (obj_grid_manager) {
	    for (var i = 0; i < grid_width; i++) {
	        for (var j = 0; j < grid_height; j++) {
	            highlight_grid[i][j] = 0;
	        }
	    }
	}
}