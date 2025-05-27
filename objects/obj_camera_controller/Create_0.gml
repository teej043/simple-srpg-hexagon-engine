/// @description Insert description here
// You can write your code in this editor

/// Initialize camera properties
camera = camera_create();

// Camera position and target
camera_x = room_width / 2;
camera_y = room_height / 2;
camera_z = -800;  // Height of camera

target_x = room_width / 2;
target_y = room_height / 2;
target_z = 0;

// Isometric angle settings
iso_rotation_x = 35.264; // arctan(1/√2)
iso_rotation_y = 45;     // 45 degrees around Y axis

// Set up the projection
var aspect_ratio = window_get_width() / window_get_height();
var view_width = 1366;
var view_height = 768;

// Calculate isometric view position
var distance = point_distance_3d(camera_x, camera_y, camera_z, target_x, target_y, target_z);
var rad_x = degtorad(iso_rotation_x);
var rad_y = degtorad(iso_rotation_y);

camera_x = target_x + distance * cos(rad_x) * sin(rad_y);
camera_y = target_y - distance * cos(rad_x) * cos(rad_y);
camera_z = target_z - distance * sin(rad_x);

// Create and set up the camera view matrix (position and orientation)
view_mat = matrix_build_lookat(camera_x, camera_y, camera_z,   // Camera position
                              target_x, target_y, target_z,     // Look-at position
                              0, 0, 1);                         // Up vector (changed to Z-up for isometric)

// Create and set up the projection matrix (changed to orthographic for true isometric)
var view_scale = 1.0;
proj_mat = matrix_build_projection_ortho(view_width * view_scale, 
                                       view_height * view_scale,
                                       1, 32000);

// Apply the matrices to the camera
camera_set_view_mat(camera, view_mat);
camera_set_proj_mat(camera, proj_mat);

// Set the camera as the active view camera
view_camera[0] = camera;

// Enable depth testing
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

// Camera control settings
camera_speed = 5;
pan_speed = 2;           // Speed of camera panning
is_panning = false;      // Whether we're currently panning
last_mouse_x = 0;        // Last mouse X position for panning
last_mouse_y = 0;        // Last mouse Y position for panning
camera_distance = distance; // Store the camera distance for later use

// Enable views in the room
view_enabled = true;
view_visible[0] = true;