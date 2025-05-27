/// Handle camera movement and updates

/// @description Maintain isometric view

/// @description Handle camera movement and panning

// Handle camera panning with CTRL + mouse
if (keyboard_check(vk_control)) {
    if (!is_panning) {
        // Start panning
        is_panning = true;
        last_mouse_x = mouse_x;
        last_mouse_y = mouse_y;
    }
    
    // Calculate mouse movement
    var mouse_dx = mouse_x - last_mouse_x;
    var mouse_dy = mouse_y - last_mouse_y;
    
    // Update target position based on mouse movement
    // We need to adjust the movement direction based on our isometric view
    var rad_y = degtorad(iso_rotation_y);
    var move_x = (mouse_dx * cos(rad_y) - mouse_dy * sin(rad_y)) * pan_speed;
    var move_y = (mouse_dx * sin(rad_y) + mouse_dy * cos(rad_y)) * pan_speed;
    
    target_x -= move_x;
    target_y -= move_y;
    
    // Update last mouse position
    last_mouse_x = mouse_x;
    last_mouse_y = mouse_y;
} else {
    is_panning = false;
}

// Recalculate camera position if needed (for example, if target moves)
var distance = point_distance_3d(camera_x, camera_y, camera_z, target_x, target_y, target_z);
var rad_x = degtorad(iso_rotation_x);
var rad_y = degtorad(iso_rotation_y);

camera_x = target_x + distance * cos(rad_x) * sin(rad_y);
camera_y = target_y - distance * cos(rad_x) * cos(rad_y);
camera_z = target_z - distance * sin(rad_x);

// Update the view matrix
view_mat = matrix_build_lookat(camera_x, camera_y, camera_z,   // Camera position
                              target_x, target_y, target_z,     // Look-at position
                              0, 0, 1);                         // Up vector (Z-up for isometric)

// Apply the updated view matrix
camera_set_view_mat(camera, view_mat);

// Add zoom control with mouse wheel (optional)
var wheel = mouse_wheel_up() - mouse_wheel_down();
if (wheel != 0) {
    camera_distance = clamp(camera_distance - wheel * 50, 400, 1200);
} 