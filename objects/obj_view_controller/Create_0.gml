/// @description Initialize view controller

// Enable views globally
view_enabled = true;

// Set up view[0] for the window/display
view_visible[0] = true;
view_xport[0] = 0;
view_yport[0] = 0;
view_wport[0] = window_get_width();
view_hport[0] = window_get_height();
view_surface_id[0] = -1;

// Create camera with a reasonable view size (same as window size)
var view_width = 1366;  // Default window width
var view_height = 768;  // Default window height
view_camera[0] = camera_create_view(0, 0, view_width, view_height, 0, -1, -1, -1, -1, -1);

// Camera bounds
cam_width = camera_get_view_width(view_camera[0]);
cam_height = camera_get_view_height(view_camera[0]);
cam_bounds_x_min = 0;
cam_bounds_y_min = 0;
cam_bounds_x_max = room_width - cam_width;
cam_bounds_y_max = room_height - cam_height;

// Camera control variables
is_panning = false;
pan_start_x = 0;
pan_start_y = 0;
view_start_x = 0;
view_start_y = 0;

// Camera following variables
follow_target = noone;      // The instance to follow
target_x = 0;              // Target x position for smooth movement
target_y = 0;              // Target y position for smooth movement
lerp_speed = 0.1;          // Smoothing factor (0 = no movement, 1 = instant)

// Team tracking
last_team = 0;  // Track team changes

/// @function set_camera_target
/// @param {id} target The instance to follow (or noone for no target)
/// @param {real} [smooth_speed] Optional: Override the default smoothing speed (0-1)
function set_camera_target(target, smooth_speed = lerp_speed) {
    follow_target = target;
    lerp_speed = smooth_speed;
    is_panning = false;  // Stop any active panning
    
    // If target is noone, keep current position as target
    if (target == noone) {
        target_x = camera_get_view_x(view_camera[0]);
        target_y = camera_get_view_y(view_camera[0]);
    }
}

// Initial camera positioning
if (instance_exists(obj_game_manager)) {
    var gm = obj_game_manager;
    if (array_length(gm.player_units) > 0) {
        // Calculate average position of all player units
        var total_x = 0;
        var total_y = 0;
        var min_x = room_width;
        var min_y = room_height;
        var max_x = 0;
        var max_y = 0;
        var valid_units = 0;
        
        for (var i = 0; i < array_length(gm.player_units); i++) {
            var unit = gm.player_units[i];
            if (instance_exists(unit)) {
                total_x += unit.x;
                total_y += unit.y;
                min_x = min(min_x, unit.x);
                min_y = min(min_y, unit.y);
                max_x = max(max_x, unit.x);
                max_y = max(max_y, unit.y);
                valid_units++;
            }
        }
        
        if (valid_units > 0) {
            var avg_x = total_x / valid_units;
            var avg_y = total_y / valid_units;
            
            // If units are spread out, adjust view to try to include all units
            var spread_x = max_x - min_x;
            var spread_y = max_y - min_y;
            
            if (spread_x > cam_width * 0.8 || spread_y > cam_height * 0.8) {
                // Units are spread out, center on the middle of their spread
                avg_x = min_x + spread_x/2;
                avg_y = min_y + spread_y/2;
            }
            
            // Set initial camera position
            var new_cam_x = clamp(avg_x - cam_width/2, cam_bounds_x_min, cam_bounds_x_max);
            var new_cam_y = clamp(avg_y - cam_height/2, cam_bounds_y_min, cam_bounds_y_max);
            
            camera_set_view_pos(view_camera[0], new_cam_x, new_cam_y);
            target_x = new_cam_x;
            target_y = new_cam_y;
            
            show_debug_message("Initial camera position set to: " + string(new_cam_x) + "," + string(new_cam_y));
        }
    }
}

// Debug initial camera state
show_debug_message("Camera initialized:");
show_debug_message("View enabled: " + string(view_enabled));
show_debug_message("View visible: " + string(view_visible[0]));
show_debug_message("View port size: " + string(view_wport[0]) + "x" + string(view_hport[0]));
show_debug_message("Camera view size: " + string(camera_get_view_width(view_camera[0])) + "x" + string(camera_get_view_height(view_camera[0])));
show_debug_message("Camera position: " + string(camera_get_view_x(view_camera[0])) + "," + string(camera_get_view_y(view_camera[0]))); 