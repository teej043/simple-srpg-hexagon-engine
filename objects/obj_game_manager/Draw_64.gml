/// @description Insert description here
// You can write your code in this editor

// Draw UI
draw_set_font(-1);
draw_set_color(c_white);

// Get camera view dimensions for proper positioning
var cam_w = camera_get_view_width(view_camera[0]);
var cam_h = camera_get_view_height(view_camera[0]);

// Check if game is over
if (game_state != "playing") {
    // Draw game over screen
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Semi-transparent background
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, cam_w, cam_h, false);
    
    // Game over text
    draw_set_alpha(1);
    if (game_state == "player_wins") {
        draw_set_color(c_lime);
        draw_text_transformed(cam_w/2, cam_h/2 - 50, "VICTORY!", 3, 3, 0);
        draw_set_color(c_white);
        draw_text(cam_w/2, cam_h/2, "Player Wins!");
    } else if (game_state == "enemy_wins") {
        draw_set_color(c_red);
        draw_text_transformed(cam_w/2, cam_h/2 - 50, "DEFEAT!", 3, 3, 0);
        draw_set_color(c_white);
        draw_text(cam_w/2, cam_h/2, "Enemy Wins!");
    }
    
    draw_set_color(c_yellow);
    draw_text(cam_w/2, cam_h/2 + 50, "Press R to restart");
    draw_text(cam_w/2, cam_h/2 + 70, "Press ESC to quit");
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    
    // Handle restart/quit input
    if (keyboard_check_pressed(ord("R"))) {
        room_restart();
    }
    if (keyboard_check_pressed(vk_escape)) {
        game_end();
    }
    
    return; // Don't draw normal UI when game is over
}

// Normal game UI
draw_text(10, 10, "Turn: " + string(turn_number));
draw_text(10, 30, "Current Team: " + (current_team == 0 ? "Player" : "Enemy"));
draw_text(10, 50, "Press SPACE to end turn");

// Unit counts
draw_text(10, 70, "Player Units: " + string(array_length(player_units)));
draw_text(150, 70, "Enemy Units: " + string(array_length(enemy_units)));

// Selected unit info
if (selected_unit != noone) {
    var unit = selected_unit;
    draw_text(10, 100, "Selected Unit:");
    draw_text(10, 120, "HP: " + string(unit.current_hp) + "/" + string(unit.max_hp));
    draw_text(10, 140, "SP: " + string(unit.current_sp) + "/" + string(unit.max_sp));
    draw_text(10, 160, "Attack: " + string(unit.attack_power));
    draw_text(10, 180, "Defense: " + string(unit.defense));
    draw_text(10, 200, "Movement: " + string(unit.movement_range));
    
    // Show action status and available actions
    var y_pos = 220;
    if (unit.has_moved) {
        draw_set_color(c_gray);
        draw_text(10, y_pos, "✓ MOVED");
        y_pos += 20;
    } else {
        draw_set_color(c_lime);
        draw_text(10, y_pos, "○ Can Move");
        y_pos += 20;
    }
    
    if (unit.has_acted) {
        draw_set_color(c_gray);
        draw_text(10, y_pos, "✓ ACTED");
        y_pos += 20;
    } else {
        draw_set_color(c_lime);
        draw_text(10, y_pos, "○ Can Attack");
        y_pos += 20;
    }
    
    draw_set_color(c_white);
    if (!unit.has_moved || !unit.has_acted) {
        draw_text(10, y_pos, "Press A for Actions");
    }
    
    // Add movement reversal instruction if available
    if (unit.can_reverse_movement && unit.has_moved && !unit.has_acted) {
        draw_set_color(c_yellow);
        draw_text(10, y_pos + 20, "ESC/Right-click: Reverse movement");
        draw_set_color(c_white);
    }
}

// Instructions (positioned at bottom of view)
draw_set_color(c_yellow);
draw_text(10, cam_h - 140, "Controls:");
draw_text(10, cam_h - 120, "Left-click: Select/Move/Attack");
draw_text(10, cam_h - 100, "Right-click: Reverse movement (if available)");
draw_text(10, cam_h - 80, "A: Open Action Panel");
draw_text(10, cam_h - 60, "Tab: Cycle through available units");
draw_text(10, cam_h - 40, "Arrow Keys: Move cursor");
draw_text(10, cam_h - 20, "Enter/Space: Select/Act with cursor");
draw_text(200, cam_h - 20, "Esc: Exit cursor mode");
draw_set_color(c_white);

// Draw Action Panel
if (action_panel_open) {
    var panel_width = 120;
    var panel_height = array_length(action_panel_actions) * 25 + 20;
    
    // Convert world coordinates to screen coordinates
    var cam_x = camera_get_view_x(view_camera[0]);
    var cam_y = camera_get_view_y(view_camera[0]);
    var screen_x = action_panel_x - cam_x;
    var screen_y = action_panel_y - cam_y;
    
    // Clamp panel to screen bounds
    screen_x = clamp(screen_x, 10, cam_w - panel_width - 10);
    screen_y = clamp(screen_y, 10, cam_h - panel_height - 10);
    
    // Draw panel background
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(screen_x, screen_y, screen_x + panel_width, screen_y + panel_height, false);
    
    // Draw panel border
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(screen_x, screen_y, screen_x + panel_width, screen_y + panel_height, true);
    
    // Draw title
    draw_set_halign(fa_center);
    draw_text(screen_x + panel_width/2, screen_y + 5, "Actions");
    draw_set_halign(fa_left);
    
    // Draw action options
    for (var i = 0; i < array_length(action_panel_actions); i++) {
        var option_y = screen_y + 25 + (i * 25);
        var action_name = action_panel_actions[i];
        
        // Highlight selected option
        if (i == action_panel_selected_index) {
            draw_set_color(c_yellow);
            draw_rectangle(screen_x + 5, option_y - 2, screen_x + panel_width - 5, option_y + 18, false);
            draw_set_color(c_black);
        } else {
            draw_set_color(c_white);
        }
        
        // Draw action name with availability indicator
        var display_text = action_name;
        if (action_name == "Spell" || action_name == "Skill") {
            display_text += " (N/A)";
            // Gray out unavailable options
            if (i != action_panel_selected_index) {
                draw_set_color(c_gray);
            }
        }
        
        draw_text(screen_x + 10, option_y, display_text);
    }
    
    // Reset color
    draw_set_color(c_white);
}