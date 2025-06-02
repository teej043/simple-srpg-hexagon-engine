/// @description Draw GUI elements after 3D rendering
gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);

// Draw health bars for all units in GUI space
var camera = camera_get_active();
var view_mat = camera_get_view_mat(camera);
var proj_mat = camera_get_proj_mat(camera);

// Draw health bars for all units
with (obj_unit) {
    // Convert 3D world position to 2D screen position
    var world_x = actual_x;
    var world_y = actual_y;
    var world_z = z; // Unit's base Z position

    // Get the unit's screen position
    var unit_screen_pos = world_to_screen(world_x, world_y, world_z, view_mat, proj_mat);

    // Check if the unit position is visible on screen
    if (unit_screen_pos[0] != -1 && unit_screen_pos[1] != -1) {
        // Position health bar above the unit on screen
        var screen_x = unit_screen_pos[0];
        var screen_y = unit_screen_pos[1] - 30; // Simple offset above the unit
        
        // Health bar properties
        var bar_width = 24;
        var bar_height = 4;
        var hp_percentage = current_hp / max_hp;
        
        // Draw background (red)
        draw_set_color(c_red);
        draw_rectangle(screen_x - bar_width/2, screen_y - bar_height/2, 
                       screen_x + bar_width/2, screen_y + bar_height/2, false);
        
        // Draw health (green)
        draw_set_color(c_green);
        draw_rectangle(screen_x - bar_width/2, screen_y - bar_height/2, 
                       screen_x - bar_width/2 + (bar_width * hp_percentage), 
                       screen_y + bar_height/2, false);
        
        // Draw border (white)
        draw_set_color(c_white);
        draw_rectangle(screen_x - bar_width/2, screen_y - bar_height/2, 
                       screen_x + bar_width/2, screen_y + bar_height/2, true);
        
        // Reset color
        draw_set_color(c_white);
    }
}