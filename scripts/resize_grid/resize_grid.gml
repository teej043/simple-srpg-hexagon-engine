// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @function resize_grid(grid_manager, new_width, new_height)
/// @description Resizes grid arrays and updates grid manager properties
/// @param {Id.Instance} grid_manager The grid manager instance to resize
/// @param {real} new_width New width of the grid in hexagons
/// @param {real} new_height New height of the grid in hexagons
function resize_grid(grid_manager, new_width, new_height){
    with (grid_manager) {
        // Store old dimensions
        var old_width = grid_width;
        var old_height = grid_height;
        
        // Update dimensions
        grid_width = new_width;
        grid_height = new_height;
        
        // Recalculate grid offset (adjusted for flat-topped with offset rows)
        var total_width = hex_width * (grid_width + 0.5);  // Add 0.5 for offset rows
        var total_height = hex_size * (grid_height * 1.5);
        grid_offset_x = (room_width - total_width) / 2;
        grid_offset_y = (room_height - total_height) / 2;
        
        // Resize grids
        var new_grid = array_create(grid_width);
        var new_movement_grid = array_create(grid_width);
        var new_highlight_grid = array_create(grid_width);
        var new_prev_highlight_grid = array_create(grid_width);
        
        for (var i = 0; i < grid_width; i++) {
            new_grid[i] = array_create(grid_height, noone);
            new_movement_grid[i] = array_create(grid_height, -1);
            new_highlight_grid[i] = array_create(grid_height, 0);
            new_prev_highlight_grid[i] = array_create(grid_height, 0);
            
            // Copy existing data if within old bounds
            for (var j = 0; j < grid_height; j++) {
                if (i < old_width && j < old_height) {
                    new_grid[i][j] = grid[i][j];
                    new_movement_grid[i][j] = movement_grid[i][j];
                    new_highlight_grid[i][j] = highlight_grid[i][j];
                    new_prev_highlight_grid[i][j] = prev_highlight_grid[i][j];
                }
            }
        }
        
        // Update grid references
        grid = new_grid;
        movement_grid = new_movement_grid;
        highlight_grid = new_highlight_grid;
        prev_highlight_grid = new_prev_highlight_grid;
        
        // Mark surfaces for update
        surface_needs_update = true;
        highlight_needs_update = true;
        
        // Update unit positions
        with (obj_unit) {
            if (grid_x >= grid_width || grid_y >= grid_height) {
                instance_destroy();
            } else {
                scr_unit_update_pixel_position(id);
            }
        }
    }
}