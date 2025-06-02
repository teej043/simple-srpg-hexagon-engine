///// @description Draw GUI elements (health bar)

//// Get the current camera matrices
//var camera = camera_get_active();
//var view_mat = camera_get_view_mat(camera);
//var proj_mat = camera_get_proj_mat(camera);

//// Convert 3D world position to 2D screen position
//// Use the unit's actual 3D position with a small offset above it for the health bar
//var healthbar_z_offset = 20; // Small offset above the unit
//var world_x = actual_x;
//var world_y = actual_y;
//var world_z = z + healthbar_z_offset; // Unit's Z position + offset

//var screen_pos = world_to_screen(world_x, world_y, + world_z, view_mat, proj_mat);

//// Check if the position is visible on screen
//if (screen_pos[0] != -1 && screen_pos[1] != -1) {
//    var screen_x = screen_pos[0];
//    var screen_y = screen_pos[1];
    
//    // Health bar properties
//    var bar_width = 24;
//    var bar_height = 4;
//    var hp_percentage = current_hp / max_hp;
    
//    // Draw background (red)
//    draw_set_color(c_red);
//    draw_rectangle(screen_x - bar_width/2, screen_y - bar_height/2, 
//                   screen_x + bar_width/2, screen_y + bar_height/2, false);
    
//    // Draw health (green)
//    draw_set_color(c_green);
//    draw_rectangle(screen_x - bar_width/2, screen_y - bar_height/2, 
//                   screen_x - bar_width/2 + (bar_width * hp_percentage), 
//                   screen_y + bar_height/2, false);
    
//    // Draw border (white)
//    draw_set_color(c_white);
//    draw_rectangle(screen_x - bar_width/2, screen_y - bar_height/2, 
//                   screen_x + bar_width/2, screen_y + bar_height/2, true);
    
//    // Reset color
//    draw_set_color(c_white);
//} 