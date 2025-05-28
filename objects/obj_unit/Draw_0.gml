/// @description Draw unit with height effect
event_inherited();
// Set color for height effect in shader (red channel affects height)
draw_set_color(make_color_rgb(32, 0, 0));  // Small height value in red channel

// Draw unit sprite at actual position with proper scaling
// draw_sprite_ext(sprite_index, image_index, actual_x, actual_y, image_xscale, 1, 0, c_white, 1);

// Reset color
draw_set_color(c_white);

// Draw HP bar (after shader reset in camera object)
var bar_width = 24;
var bar_height = 4;
var hp_percentage = current_hp / max_hp;
var healthbar_offset = 33;

draw_set_color(c_red);
draw_rectangle(actual_x - bar_width/2, actual_y - sprite_height/2 - healthbar_offset, 
               actual_x + bar_width/2, actual_y - sprite_height/2 - healthbar_offset + bar_height, false);

draw_set_color(c_green);
draw_rectangle(actual_x - bar_width/2, actual_y - sprite_height/2 - healthbar_offset, 
               actual_x - bar_width/2 + (bar_width * hp_percentage), 
               actual_y - sprite_height/2 - healthbar_offset + bar_height, false);

draw_set_color(c_white);
draw_rectangle(actual_x - bar_width/2, actual_y - sprite_height/2 - healthbar_offset, 
               actual_x + bar_width/2, actual_y - sprite_height/2 - healthbar_offset + bar_height, true);

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