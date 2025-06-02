/// @description Set up 3D camera

// Set up window and application surface
window_set_size(1600, 900);
surface_resize(application_surface, 1600, 900);
window_center();

//// Enable views and set up view size
//view_enabled = true;
//view_visible[0] = true;

//// Set up view port (where in the window to draw)
//view_xport[0] = 0;
//view_yport[0] = 0;
//view_wport[0] = window_get_width();
//view_hport[0] = window_get_height();

//// Set up view size (how much of the room to show)
//view_camera[0] = camera_create();
//camera_set_view_size(view_camera[0], 800, 450);  // Show less of the room

// Enable depth for 3D rendering
//gpu_set_zwriteenable(true);
//gpu_set_ztestenable(true);

// Force all layers to use depth
layer_force_draw_depth(true, 1);

// Camera settings
camera_distance = 1000;  // Distance behind target
camera_height = 400;   // Height above target
camera_target_x = room_width/2;
camera_target_y = room_height/2;
camera_target_z = 0;

camera_distance_far = 1500;

// Distance interpolation for smooth transitions
current_distance = camera_distance_far;  // Start with far distance
distance_lerp_speed = 0.05;  // Controls how fast distance changes (lower = smoother)

// Smooth camera movement
lerp_speed = 0.1;

// Remove grass creation since we don't need it for the tactical game