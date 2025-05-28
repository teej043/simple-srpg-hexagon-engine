/// @description Insert description here
// You can write your code in this editor

// Check for end turn (only during player's turn and no unit is moving)
var any_unit_moving = false;
with (obj_unit) {
    if (is_moving) {
        any_unit_moving = true;
        break;
    }
}

if (keyboard_check_pressed(vk_space) && current_team == 0 && !any_unit_moving) {
    scr_game_end_turn();
}

// Check win conditions
var win_state = scr_game_check_win_condition();

// Handle game over states
if (win_state != "playing") {
    // Stop all unit actions
    with (obj_unit) {
        is_selected = false;
        has_acted = true;
        has_moved = true;
    }
    selected_unit = noone;
    scr_clear_highlights();
}