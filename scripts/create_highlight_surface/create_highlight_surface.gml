// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @function create_highlight_surface(existing_surface, grid_width, grid_height, hex_size, highlight_grid, surface_width, surface_height)
/// @description Creates a surface with colored highlight hexagons based on highlight grid
/// @param {Id.Surface} existing_surface Existing surface to free (-1 if none)
/// @param {real} grid_width Width of the grid in hexagons
/// @param {real} grid_height Height of the grid in hexagons
/// @param {real} hex_size Size of each hexagon
/// @param {array} highlight_grid 2D array containing highlight values
/// @param {real} surface_width Width of the surface to create
/// @param {real} surface_height Height of the surface to create
/// @returns {Id.Surface} The created surface
function create_highlight_surface(existing_surface, grid_width, grid_height, hex_size, highlight_grid, surface_width, surface_height){
    if (existing_surface != -1) {
        surface_free(existing_surface);
    }
    
    var new_surface = surface_create(surface_width, surface_height);
    surface_set_target(new_surface);
    draw_clear_alpha(c_black, 0);
    
    // Draw only colored highlights (skip case 0 - normal/gray)
    
    for (var q = 0; q < grid_width; q++) {
        for (var r = 0; r < grid_height; r++) {
            // Skip normal status (case 0) since sprite-based hexagons provide the base
            if (highlight_grid[q][r] == 0) continue;
            
            var pos = hex_to_pixel(q, r);
            
            // Set color based on highlight (only colored highlights)
            switch (highlight_grid[q][r]) {
                case 1: draw_set_color(c_blue); break;       // Movement
                case 2: draw_set_color(c_red); break;        // Attack
                case 3: draw_set_color(c_green); break;      // Selected
                case 4: draw_set_color(c_yellow); break;     // Keyboard cursor
            }
            
            draw_hexagon(pos[0], pos[1], hex_size, true);
        }
    }
    
    draw_set_alpha(1);
    surface_reset_target();
    return new_surface;
}