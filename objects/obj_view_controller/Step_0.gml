/// @description Handle camera movement

// Get the current camera position
var current_x = camera_get_view_x(view_camera[0]);
var current_y = camera_get_view_y(view_camera[0]);

// Get window mouse coordinates
var mouse_x_pos = display_mouse_get_x();
var mouse_y_pos = display_mouse_get_y();

// Check for middle mouse button to start panning
if (mouse_check_button_pressed(mb_middle)) {
    is_panning = true;
    pan_start_x = mouse_x_pos;
    pan_start_y = mouse_y_pos;
    view_start_x = current_x;
    view_start_y = current_y;
    follow_target = noone; // Stop following when manual panning starts
}

// Handle active panning
if (is_panning) {
    if (mouse_check_button(mb_middle)) {
        var dx = (pan_start_x - mouse_x_pos);
        var dy = (pan_start_y - mouse_y_pos);
        
        // Scale the movement
        var move_scale = 1.0;
        dx *= move_scale;
        dy *= move_scale;
        
        target_x = clamp(view_start_x + dx, cam_bounds_x_min, cam_bounds_x_max);
        target_y = clamp(view_start_y + dy, cam_bounds_y_min, cam_bounds_y_max);
    } else {
        is_panning = false;
    }
}

// Check for unit to follow
if (!is_panning && instance_exists(obj_game_manager)) {
    var gm = obj_game_manager;
    
    // Check for team change
    if (last_team != gm.current_team) {
        show_debug_message("Team changed from " + string(last_team) + " to " + string(gm.current_team));
        last_team = gm.current_team;
        follow_target = noone; // Reset following when team changes
        
        if (gm.current_team == 1) {
            // If switching to enemy turn, immediately center on first active enemy unit
            for (var i = 0; i < array_length(gm.enemy_units); i++) {
                var unit = gm.enemy_units[i];
                if (!unit.has_acted && instance_exists(unit)) {
                    // Instantly center camera on first enemy unit
                    camera_set_view_pos(view_camera[0], 
                        clamp(unit.x - cam_width/2, cam_bounds_x_min, cam_bounds_x_max),
                        clamp(unit.y - cam_height/2, cam_bounds_y_min, cam_bounds_y_max)
                    );
                    set_camera_target(unit);
                    show_debug_message("Centered on enemy unit at: " + string(unit.x) + "," + string(unit.y));
                    break;
                }
            }
        } else {
            // If switching to player turn, center on all player units
            var player_count = array_length(gm.player_units);
            show_debug_message("Player turn start. Player units: " + string(player_count));
            
            if (player_count > 0) {
                // Calculate average position of all player units
                var total_x = 0;
                var total_y = 0;
                var min_x = room_width;
                var min_y = room_height;
                var max_x = 0;
                var max_y = 0;
                var valid_units = 0;
                
                for (var i = 0; i < player_count; i++) {
                    var unit = gm.player_units[i];
                    if (instance_exists(unit)) {
                        total_x += unit.x;
                        total_y += unit.y;
                        min_x = min(min_x, unit.x);
                        min_y = min(min_y, unit.y);
                        max_x = max(max_x, unit.x);
                        max_y = max(max_y, unit.y);
                        valid_units++;
                        show_debug_message("Player unit " + string(i) + " at: " + string(unit.x) + "," + string(unit.y));
                    }
                }
                
                if (valid_units > 0) {
                    var avg_x = total_x / valid_units;
                    var avg_y = total_y / valid_units;
                    
                    // If units are spread out, adjust view to try to include all units
                    var spread_x = max_x - min_x;
                    var spread_y = max_y - min_y;
                    
                    show_debug_message("Unit spread: " + string(spread_x) + "x" + string(spread_y));
                    show_debug_message("View size: " + string(cam_width) + "x" + string(cam_height));
                    
                    if (spread_x > cam_width * 0.8 || spread_y > cam_height * 0.8) {
                        // Units are spread out, center on the middle of their spread
                        avg_x = min_x + spread_x/2;
                        avg_y = min_y + spread_y/2;
                        show_debug_message("Units spread out, centering on middle: " + string(avg_x) + "," + string(avg_y));
                    } else {
                        show_debug_message("Units clustered, centering on average: " + string(avg_x) + "," + string(avg_y));
                    }
                    
                    // Instantly center camera on calculated position
                    var new_cam_x = clamp(avg_x - cam_width/2, cam_bounds_x_min, cam_bounds_x_max);
                    var new_cam_y = clamp(avg_y - cam_height/2, cam_bounds_y_min, cam_bounds_y_max);
                    
                    camera_set_view_pos(view_camera[0], new_cam_x, new_cam_y);
                    target_x = new_cam_x;
                    target_y = new_cam_y;
                    
                    show_debug_message("Camera positioned at: " + string(new_cam_x) + "," + string(new_cam_y));
                }
            }
        }
    }
    
    // First priority: Follow selected unit if one exists
    if (gm.selected_unit != noone && instance_exists(gm.selected_unit)) {
        if (follow_target != gm.selected_unit) {
            set_camera_target(gm.selected_unit);
        }
    }
    // Second priority: During enemy turn, find active enemy unit
    else if (gm.current_team == 1 && follow_target == noone) {
        for (var i = 0; i < array_length(gm.enemy_units); i++) {
            var unit = gm.enemy_units[i];
            if (!unit.has_acted && instance_exists(unit)) {
                set_camera_target(unit);
                break;
            }
        }
    }
}

// Update camera position based on target
if (follow_target != noone && instance_exists(follow_target)) {
    // Calculate target position (centered on followed instance)
    target_x = clamp(follow_target.x - cam_width/2, cam_bounds_x_min, cam_bounds_x_max);
    target_y = clamp(follow_target.y - cam_height/2, cam_bounds_y_min, cam_bounds_y_max);
    
    // Only stop following if the unit has completed ALL actions AND is not moving
    if (follow_target.has_moved && follow_target.has_acted && !follow_target.is_moving) {
        show_debug_message("[CAMERA] Stopped following " + follow_target.unit_type + " - actions completed");
        follow_target = noone;
    }
}

// Smoothly move camera to target position
var new_x = lerp(current_x, target_x, lerp_speed);
var new_y = lerp(current_y, target_y, lerp_speed);

// Update camera position
camera_set_view_pos(view_camera[0], new_x, new_y);
