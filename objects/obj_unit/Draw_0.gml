/// @description Insert description here
// You can write your code in this editor

// Draw unit
draw_self();

// Draw HP bar
var bar_width = 24;
var bar_height = 4;
var hp_percentage = current_hp / max_hp;

draw_set_color(c_red);
draw_rectangle(x - bar_width/2, y - sprite_height/2 - 8, 
               x + bar_width/2, y - sprite_height/2 - 8 + bar_height, false);

draw_set_color(c_green);
draw_rectangle(x - bar_width/2, y - sprite_height/2 - 8, 
               x - bar_width/2 + (bar_width * hp_percentage), 
               y - sprite_height/2 - 8 + bar_height, false);

draw_set_color(c_white);
draw_rectangle(x - bar_width/2, y - sprite_height/2 - 8, 
               x + bar_width/2, y - sprite_height/2 - 8 + bar_height, true);

// Draw selection indicator
if (is_selected) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.5);
    draw_circle(x, y, sprite_width/2 + 4, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// Draw team indicator
draw_set_color(team == 0 ? c_blue : c_red);
draw_circle(x + 12, y - 12, 4, false);
draw_set_color(c_white);