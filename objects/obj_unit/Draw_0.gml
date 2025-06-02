/// @description Draw unit with height effect

// Disable automatic sprite drawing to prevent shadows/duplicates


// Don't call event_inherited() since we need custom positioning and image_index
// Instead, apply the diorama shading effect manually with correct parameters

// Set color for height effect in shader (red channel affects height)
draw_set_color(make_color_rgb(32, 0, 0));  // Small height value in red channel

// Draw unit sprite using the parent's diorama shading approach but with correct positioning and image_index
var c_bottom = make_color_rgb(0, 0, 0);
var c_top = make_color_rgb(sprite_height, 0, 0);
draw_sprite_general(sprite_index, image_index, 0, 0, sprite_width, sprite_height, actual_x, actual_y, image_xscale, 1, 0, c_top, c_top, c_bottom, c_bottom, 1);

// Reset color
draw_set_color(c_white);

// Draw selection indicator
if (is_selected) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.5);
    draw_circle(actual_x, actual_y, sprite_width/2 + 4, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// Draw team indicator
draw_set_color(team == 0 ? c_blue : c_red);
draw_circle(actual_x + 12, actual_y - 12, 4, false);
draw_set_color(c_white);