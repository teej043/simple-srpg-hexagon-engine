// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @function create_base_grid_surface(existing_surface, grid_width, grid_height, hex_size, surface_width, surface_height)
/// @description Creates a surface with hexagon grid outlines in white
/// @param {Id.Surface} existing_surface Existing surface to free (-1 if none)
/// @param {real} grid_width Width of the grid in hexagons
/// @param {real} grid_height Height of the grid in hexagons
/// @param {real} hex_size Size of each hexagon
/// @param {real} surface_width Width of the surface to create
/// @param {real} surface_height Height of the surface to create
/// @returns {Id.Surface} The created surface
function create_base_grid_surface(existing_surface, grid_width, grid_height, hex_size, surface_width, surface_height){
    if (existing_surface != -1) {
        surface_free(existing_surface);
    }
    
    var new_surface = surface_create(surface_width, surface_height);
    surface_set_target(new_surface);
    draw_clear_alpha(c_black, 0);
    
    // Draw all hexagon outlines in white
    draw_set_color(c_white);
    draw_set_alpha(1);
    
    for (var q = 0; q < grid_width; q++) {
        for (var r = 0; r < grid_height; r++) {
            var pos = hex_to_pixel(q, r);
            draw_hexagon(pos[0], pos[1], hex_size, false);
        }
    }
    
    surface_reset_target();
    return new_surface;
}