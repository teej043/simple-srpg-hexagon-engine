// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @function scr_clear_highlights()
/// @description Clear all grid highlights
function scr_clear_highlights(){
	/// Clear all grid highlights
	with (obj_grid_manager) {
	    for (var i = 0; i < grid_width; i++) {
	        for (var j = 0; j < grid_height; j++) {
	            highlight_grid[i][j] = 0;
	        }
	    }
	    
	    // Mark highlight surface for update
	    highlight_needs_update = true;
	}
}

/// @function update_prev_highlights_array(grid_width, grid_height, highlight_grid, prev_highlight_grid)
/// @description Updates the previous highlight grid with current values
/// @param {real} grid_width Width of the grid in hexagons
/// @param {real} grid_height Height of the grid in hexagons
/// @param {array} highlight_grid Current 2D array containing highlight values
/// @param {array} prev_highlight_grid Previous 2D array to update
function update_prev_highlights_array(grid_width, grid_height, highlight_grid, prev_highlight_grid) {
    for (var q = 0; q < grid_width; q++) {
        for (var r = 0; r < grid_height; r++) {
            prev_highlight_grid[q][r] = highlight_grid[q][r];
        }
    }
}