/// @description Handle rendering with diorama shader

// Update camera target based on selected unit or middle of screen
if (instance_exists(obj_game_manager)) {
    var gm = obj_game_manager;
    if (gm.selected_unit != noone && instance_exists(gm.selected_unit)) {
        camera_target_x = lerp(camera_target_x, gm.selected_unit.x, lerp_speed);
        camera_target_y = lerp(camera_target_y, gm.selected_unit.y, lerp_speed);
    }
}

// Calculate camera position
var xto = camera_target_x;
var yto = camera_target_y;
var zto = camera_target_z;

var xfrom = camera_target_x;
var yfrom = camera_target_y + camera_distance;
var zfrom = camera_height;

// Set up the 3D camera
var camera = camera_get_active();
camera_set_view_mat(camera, matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1));
camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-20, -window_get_width() / window_get_height(), 5, 1000));
camera_apply(camera);

//// Clear the screen and set up 3D rendering
//draw_clear(c_black);
//gpu_set_zwriteenable(true);
//gpu_set_ztestenable(true);
//gpu_set_alphatestenable(true);

// Apply the diorama shader for 3D effect
shader_set(shd_diorama);

// Draw all units
with (par_obj) {
    event_perform(ev_draw, 0);
}

// Reset shader
shader_reset();