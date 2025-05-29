/// @description Insert description here
// You can write your code in this editor

// Draw UI
draw_set_font(-1);
draw_set_color(c_white);

// Check if game is over
if (game_state != "playing") {
    // Draw game over screen
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Semi-transparent background
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, room_width, room_height, false);
    
    // Game over text
    draw_set_alpha(1);
    if (game_state == "player_wins") {
        draw_set_color(c_lime);
        draw_text_transformed(room_width/2, room_height/2 - 50, "VICTORY!", 3, 3, 0);
        draw_set_color(c_white);
        draw_text(room_width/2, room_height/2, "Player Wins!");
    } else if (game_state == "enemy_wins") {
        draw_set_color(c_red);
        draw_text_transformed(room_width/2, room_height/2 - 50, "DEFEAT!", 3, 3, 0);
        draw_set_color(c_white);
        draw_text(room_width/2, room_height/2, "Enemy Wins!");
    }
    
    draw_set_color(c_yellow);
    draw_text(room_width/2, room_height/2 + 50, "Press R to restart");
    draw_text(room_width/2, room_height/2 + 70, "Press ESC to quit");
    
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
        draw_text(10, y_pos, "Right-click to Wait");
    }
}

// Instructions
draw_set_color(c_yellow);
draw_text(10, room_height - 120, "Controls:");
draw_text(10, room_height - 100, "Left-click: Select/Move/Attack");
draw_text(10, room_height - 80, "Right-click: Wait (end unit turn)");
draw_text(10, room_height - 60, "Tab: Cycle through available units");
draw_text(10, room_height - 40, "Arrow Keys: Move cursor");
draw_text(10, room_height - 20, "Enter/Space: Select/Act with cursor");
draw_text(200, room_height - 20, "Esc: Exit cursor mode");
draw_set_color(c_white);