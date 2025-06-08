// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @function is_highlights_changed(grid_width, grid_height, highlight_grid, prev_highlight_grid)
/// @description Checks if the highlight grid has changed since the previous state
/// @param {real} grid_width Width of the grid in hexagons
/// @param {real} grid_height Height of the grid in hexagons
/// @param {array} highlight_grid Current 2D array containing highlight values
/// @param {array} prev_highlight_grid Previous 2D array containing highlight values
/// @returns {bool} True if highlights have changed, false otherwise
function is_highlights_changed(grid_width, grid_height, highlight_grid, prev_highlight_grid){
    for (var q = 0; q < grid_width; q++) {
        for (var r = 0; r < grid_height; r++) {
            if (highlight_grid[q][r] != prev_highlight_grid[q][r]) {
                return true;
            }
        }
    }
    return false;
}