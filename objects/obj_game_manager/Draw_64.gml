/// @description Insert description here
// You can write your code in this editor

// Draw UI
draw_set_font(-1);
draw_set_color(c_white);

// Check if game is over (using both old and new state systems)
var is_game_over = (old_game_state != "playing" || game_state == GameState.GAME_OVER);

if (is_game_over) {
    // Draw game over screen
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Semi-transparent background
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, room_width, room_height, false);
    
    // Game over text
    draw_set_alpha(1);
    if (old_game_state == "player_wins") {
        draw_set_color(c_lime);
        draw_text_transformed(room_width/2, room_height/2 - 50, "VICTORY!", 3, 3, 0);
        draw_set_color(c_white);
        draw_text(room_width/2, room_height/2, "Player Wins!");
    } else if (old_game_state == "enemy_wins") {
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

// Display current team and game state
var team_text = (current_team == 0) ? "Player" : "Enemy";
var state_text = "";
switch(game_state) {
    case GameState.WAITING_FOR_INPUT:
        state_text = " (Ready)";
        break;
    case GameState.PROCESSING_ACTION:
        state_text = " (Action)";
        break;
    case GameState.AI_THINKING:
        state_text = " (Thinking)";
        break;
    case GameState.TRANSITIONING:
        state_text = " (Transitioning)";
        break;
}

draw_text(10, 30, "Current Team: " + team_text + state_text);

// Show action queue status
if (!ds_queue_empty(action_queue) || action_in_progress) {
    var queue_text = "Actions: ";
    if (action_in_progress) {
        queue_text += "Processing";
        if (current_action != noone) {
            switch(current_action.type) {
                case ACTION_TYPE.MOVE:
                    queue_text += " Move";
                    break;
                case ACTION_TYPE.ATTACK:
                    queue_text += " Attack";
                    break;
                case ACTION_TYPE.CAST_SPELL:
                    queue_text += " Spell";
                    break;
                case ACTION_TYPE.WAIT:
                    queue_text += " Wait";
                    break;
            }
        }
    }
    if (!ds_queue_empty(action_queue)) {
        queue_text += " (+" + string(ds_queue_size(action_queue)) + " queued)";
    }
    draw_text(10, 50, queue_text);
    draw_text(10, 70, "Press SPACE to skip animation");
} else {
    draw_text(10, 50, "Press SPACE to end turn");
}

// Unit counts
draw_text(10, 90, "Player Units: " + string(array_length(player_units)));
draw_text(150, 90, "Enemy Units: " + string(array_length(enemy_units)));

// Targeting mode indicator
if (targeting_mode != TargetingMode.NONE) {
    draw_set_color(c_yellow);
    var target_text = "TARGETING: ";
    switch(targeting_mode) {
        case TargetingMode.SINGLE_TARGET:
            target_text += "Single Target";
            break;
        case TargetingMode.AOE_RADIUS:
            target_text += "Area of Effect";
            break;
        case TargetingMode.AOE_LINE:
            target_text += "Line Attack";
            break;
    }
    target_text += " (ESC to cancel)";
    draw_text(10, 110, target_text);
    draw_set_color(c_white);
}

// Selected unit info
if (selected_unit != noone && instance_exists(selected_unit)) {
    var unit = selected_unit;
    var y_start = 130;
    
    draw_text(10, y_start, "Selected Unit: " + unit.unit_type);
    draw_text(10, y_start + 20, "HP: " + string(unit.current_hp) + "/" + string(unit.max_hp));
    draw_text(10, y_start + 40, "SP: " + string(unit.current_sp) + "/" + string(unit.max_sp));
    draw_text(10, y_start + 60, "ATK: " + string(unit.attack_power) + " | DEF: " + string(unit.defense));
    draw_text(10, y_start + 80, "Movement: " + string(unit.movement_range));
    
    // Action status
    var action_status = "Actions: ";
    if (unit.has_moved) action_status += "Moved ";
    if (unit.has_acted) action_status += "Acted ";
    if (!unit.has_moved && !unit.has_acted) action_status += "Ready";
    
    draw_text(10, y_start + 100, action_status);
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