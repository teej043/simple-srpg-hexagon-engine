/// @description Insert description here
// You can write your code in this editor

// Handle unit selection and actions
if (mouse_check_button_pressed(mb_left)) {
    var mouse_hex = pixel_to_hex(mouse_x, mouse_y);
    var mouse_q = mouse_hex[0];
    var mouse_r = mouse_hex[1];
    
    // Check if clicking on this unit
    if (mouse_q == grid_x && mouse_r == grid_y && !has_acted) {
        if (obj_game_manager.current_team == team) {
            scr_unit_select(id);
        }
    }
    // Check if this unit is selected and clicking elsewhere
    else if (is_selected) {
        scr_unit_handle_action(id, mouse_q, mouse_r);
    }
}

// Right-click to wait/end turn for selected unit
if (mouse_check_button_pressed(mb_right) && is_selected) {
    scr_unit_wait(id);
}