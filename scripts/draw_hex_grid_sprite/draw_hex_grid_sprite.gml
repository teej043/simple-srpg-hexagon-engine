// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @function draw_hex_grid_sprite(grid_width, grid_height, hex_size, sprite_index)
/// @description Draws a sprite-based hexagon grid with viewport culling optimization
/// @param {real} grid_width Width of the grid in hexagons
/// @param {real} grid_height Height of the grid in hexagons  
/// @param {real} hex_size Size of each hexagon
/// @param {Asset.GMSprite} sprite_index Default sprite to use for hexagons (used as fallback)
function draw_hex_grid_sprite(grid_width, grid_height, hex_size, sprite_index){
    // Get camera bounds for viewport culling
    var cam_x = camera_get_view_x(view_camera[0]);
    var cam_y = camera_get_view_y(view_camera[0]);
    var cam_w = camera_get_view_width(view_camera[0]);
    var cam_h = camera_get_view_height(view_camera[0]);
    
    // Draw terrain-specific hexagon sprites
    for (var q = 0; q < grid_width; q++) {
        for (var r = 0; r < grid_height; r++) {
            var pos = hex_to_pixel(q, r);
            var x_pos = round(pos[0]); // Round to integer pixels
            var y_pos = round(pos[1]); // Round to integer pixels
            
            // Viewport culling - skip if hexagon is outside camera view
            if (x_pos < cam_x - hex_size || x_pos > cam_x + cam_w + hex_size ||
                y_pos < cam_y - hex_size || y_pos > cam_y + cam_h + hex_size) {
                continue;
            }
            
            // Get terrain-specific sprite
            var terrain_type = obj_grid_manager.get_terrain_at(q, r);
            var terrain_sprite = obj_grid_manager.get_terrain_sprite(terrain_type);
            
            // Draw terrain-specific hexagon sprite
            draw_sprite(terrain_sprite, 0, x_pos, y_pos);
        }
    }
}