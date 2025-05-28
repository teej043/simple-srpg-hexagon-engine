/// @description Set up 3D camera and rendering state

// Calculate camera position
var xto = camera_target_x;
var yto = camera_target_y;
var zto = 40;

var xfrom = camera_target_x;
var yfrom = camera_target_y + 400;
var zfrom = 600;

// Set up the 3D camera
var cam = camera_get_active();
camera_set_view_mat(cam, matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1));
camera_set_proj_mat(cam, matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 1000));
camera_apply(cam);

// Clear the screen and set up 3D rendering
draw_clear(c_black);
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);

gpu_set_alphatestenable(254);