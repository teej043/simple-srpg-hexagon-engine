/// @description Handle rendering with diorama shader

// Update camera target based on selected unit or middle of screen
if (instance_exists(obj_game_manager)) {
    var gm = obj_game_manager;
    
    // First priority: Follow selected unit if one exists
    if (gm.selected_unit != noone && instance_exists(gm.selected_unit)) {
        // Check if we should track between unit and cursor
        if (gm.cursor_active && 
            (gm.cursor_q != gm.selected_unit.grid_x || gm.cursor_r != gm.selected_unit.grid_y)) {
            
            // Calculate midpoint between selected unit and cursor
            var unit_pos = hex_to_pixel(gm.selected_unit.grid_x, gm.selected_unit.grid_y);
            var cursor_pos = hex_to_pixel(gm.cursor_q, gm.cursor_r);
            
            var midpoint_x = (unit_pos[0] + cursor_pos[0]) / 2;
            var midpoint_y = (unit_pos[1] + cursor_pos[1]) / 2;
            
            // Smoothly lerp camera to midpoint
            camera_target_x = lerp(camera_target_x, midpoint_x, lerp_speed);
            camera_target_y = lerp(camera_target_y, midpoint_y, lerp_speed);
        } else {
            // Normal unit tracking when cursor is not active or at same position
            camera_target_x = lerp(camera_target_x, gm.selected_unit.x, lerp_speed);
            camera_target_y = lerp(camera_target_y, gm.selected_unit.y, lerp_speed);
        }
    }
    // Second priority: During enemy turn, follow active enemy units
    else if (gm.current_team == 1) {
        // Find the first enemy unit that hasn't acted yet
        var active_enemy = noone;
        for (var i = 0; i < array_length(gm.enemy_units); i++) {
            var unit = gm.enemy_units[i];
            if (!unit.has_acted && instance_exists(unit)) {
                active_enemy = unit;
                break;
            }
        }
        
        // If we found an active enemy, follow it
        if (active_enemy != noone) {
            camera_target_x = lerp(camera_target_x, active_enemy.x, lerp_speed);
            camera_target_y = lerp(camera_target_y, active_enemy.y, lerp_speed);
        }
    }
}

// Determine target distance based on unit selection or enemy turn
var target_distance;
var should_zoom_in = false;

// Check if we should zoom in (either selected unit or following enemy)
if (obj_game_manager.selected_unit != noone) {
    should_zoom_in = true;
} else if (obj_game_manager.current_team == 1) {
    // During enemy turn, check if we have an active enemy to follow
    for (var i = 0; i < array_length(obj_game_manager.enemy_units); i++) {
        var unit = obj_game_manager.enemy_units[i];
        if (!unit.has_acted && instance_exists(unit)) {
            should_zoom_in = true;
            break;
        }
    }
}

if (should_zoom_in) {
    target_distance = camera_distance;
} else {
    target_distance = camera_distance_far;
}

// Smoothly interpolate current distance to target distance
current_distance = lerp(current_distance, target_distance, distance_lerp_speed);

// Calculate camera position
var xto = camera_target_x;
var yto = camera_target_y;
var zto = camera_target_z;

var xfrom = camera_target_x;
var yfrom, zfrom;

// Different camera positioning based on unit selection
if (should_zoom_in) {
    // Unit active (selected or enemy being followed): normal horizontal view (behind the unit)
    yfrom = camera_target_y + current_distance;
    zfrom = camera_height;
} else {
    // No unit active: 30-degree top-down view
    var angle_rad = degtorad(30);  // 30 degrees in radians
    yfrom = camera_target_y + (current_distance * cos(angle_rad));  // Horizontal component
    zfrom = camera_height + (current_distance * sin(angle_rad));    // Vertical component
}

// Set up the 3D camera
var camera = camera_get_active();
camera_set_view_mat(camera, matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1));
camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-20, -window_get_width() / window_get_height(), 5, 64000));
camera_apply(camera);

//// Clear the screen and set up 3D rendering
//draw_clear(c_black);
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);

// Apply the diorama shader for 3D effect
shader_set(shd_diorama);

// Draw all units
with (par_obj) {
    event_perform(ev_draw, 0);
}

// Reset shader
shader_reset();