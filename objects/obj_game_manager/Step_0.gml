/// @description Insert description here
// You can write your code in this editor

// Process action queue
if (game_state == GameState.PROCESSING_ACTION && !action_in_progress) {
    process_next_action();
}

// Check for end turn (only during player's turn and when can accept input)
if (keyboard_check_pressed(vk_space) && can_accept_input()) {
    // Check if space is being used to skip animation
    if (action_in_progress) {
        skip_current_animation();
    } else {
        scr_game_end_turn();
    }
}

// Handle tab selection for player units (only when can accept input)
if (can_accept_input()) {
    if (keyboard_check_pressed(vk_tab) && can_tab_select) {
        var active_units = [];
        
        // Collect all player units that haven't completed their turn
        for (var i = 0; i < array_length(player_units); i++) {
            var unit = player_units[i];
            if (instance_exists(unit) && (!unit.has_moved || !unit.has_acted)) {
                array_push(active_units, unit);
            }
        }
        
        // If we have active units
        if (array_length(active_units) > 0) {
            // Clear previous selection
            if (selected_unit != noone) {
                selected_unit.is_selected = false;
            }
            
            // Update tab index
            tab_selection_index = (tab_selection_index + 1) % array_length(active_units);
            
            // Select the next unit
            selected_unit = active_units[tab_selection_index];
            selected_unit.is_selected = true;
            
            // Reset cursor position to the newly selected unit when using tab
            if (cursor_active) {
                cursor_q = selected_unit.grid_x;
                cursor_r = selected_unit.grid_y;
                show_debug_message("Tab selected new unit and moved cursor to: " + string(cursor_q) + "," + string(cursor_r));
            }
            
            // Clear any existing highlights and targeting
            cancel_targeting();
            
            // Show movement range for newly selected unit
            if (!selected_unit.has_moved) {
                calculate_movement_range(selected_unit);
            }
            // Show attack range if unit can still act
            else if (!selected_unit.has_acted) {
                calculate_attack_range(selected_unit);
            }
            
            // Highlight the selected unit's position
            obj_grid_manager.highlight_grid[selected_unit.grid_x][selected_unit.grid_y] = 3;
        }
        
        // Set the flag and start the alarm
        can_tab_select = false;
        alarm[2] = 10; // About 1/6th of a second at 60fps
    }
}

// Handle keyboard cursor (only when can accept input)
if (can_accept_input()) {
    // Check for any arrow key press to activate cursor
    if (!cursor_active && (
        keyboard_check_pressed(vk_left) || 
        keyboard_check_pressed(vk_right) || 
        keyboard_check_pressed(vk_up) || 
        keyboard_check_pressed(vk_down)
    )) {
        cursor_active = true;
        // If we have a selected unit, start at its position
        if (selected_unit != noone) {
            cursor_q = selected_unit.grid_x;
            cursor_r = selected_unit.grid_y;
        } else {
            // Start at first player unit's position
            for (var i = 0; i < array_length(player_units); i++) {
                if (instance_exists(player_units[i])) {
                    cursor_q = player_units[i].grid_x;
                    cursor_r = player_units[i].grid_y;
                    break;
                }
            }
        }
    }
    
    if (cursor_active) {
        // Handle cursor movement with delay
        if (cursor_move_timer <= 0) {
            var moved = false;
            
            // Get the correct hex directions based on the current row
            var directions = obj_grid_manager.get_hex_directions(cursor_r);
            var dir_index = -1;
            
            // Check arrow keys and map to hex directions
            if (keyboard_check(vk_right)) {
                dir_index = 0; // right
            } else if (keyboard_check(vk_left)) {
                dir_index = 3; // left
            } else if (keyboard_check(vk_up)) {
                if (cursor_r % 2 == 0) {
                    dir_index = 5; // top right for even rows
                } else {
                    dir_index = 4; // top left for odd rows
                }
            } else if (keyboard_check(vk_down)) {
                if (cursor_r % 2 == 0) {
                    dir_index = 1; // bottom right for even rows
                } else {
                    dir_index = 2; // bottom left for odd rows
                }
            }
            
            // Move cursor if a direction was chosen
            if (dir_index != -1) {
                var new_q = cursor_q + directions[dir_index][0];
                var new_r = cursor_r + directions[dir_index][1];
                
                // Check if the new position is valid
                if (is_valid_position(new_q, new_r)) {
                    cursor_q = new_q;
                    cursor_r = new_r;
                    moved = true;
                }
            }
            
            // If cursor moved, reset the timer
            if (moved) {
                cursor_move_timer = cursor_move_delay;
            }
        } else {
            cursor_move_timer--;
        }
        
        // Update highlights whenever cursor is active
        scr_clear_highlights();
        
        // If there's a selected unit, show its ranges
        if (selected_unit != noone) {
            if (!selected_unit.has_moved) {
                calculate_movement_range(selected_unit);
            } else if (!selected_unit.has_acted) {
                show_debug_message("Showing attack range");
                calculate_attack_range(selected_unit);
            }
            obj_grid_manager.highlight_grid[selected_unit.grid_x][selected_unit.grid_y] = 3;
        }
        
        // Handle enter key for selection/action (using new action system)
        if (keyboard_check_pressed(vk_enter)) {
            show_debug_message("Enter key pressed at cursor position: " + string(cursor_q) + "," + string(cursor_r));
            
            // First check if we have a selected unit
            if (selected_unit != noone) {
                show_debug_message("Checking action with selected unit at: " + string(selected_unit.grid_x) + "," + string(selected_unit.grid_y));
                
                // Use new action system to process the input
                if (process_unit_action_input(selected_unit, cursor_q, cursor_r)) {
                    exit; // Action was processed
                }
            }
            
            // If no action was performed, try to select a unit
            var unit_at_cursor = get_unit_at(cursor_q, cursor_r);
            show_debug_message("Checking for unit selection. Unit at cursor: " + string(unit_at_cursor));
            
            if (unit_at_cursor != noone && unit_at_cursor.team == current_team && !unit_at_cursor.has_acted) {
                show_debug_message("Found valid player unit to select");
                if (unit_at_cursor != selected_unit) {
                    scr_unit_select(unit_at_cursor);
                    // Reset cursor position to the newly selected unit
                    cursor_q = unit_at_cursor.grid_x;
                    cursor_r = unit_at_cursor.grid_y;
                    show_debug_message("Selected new unit and moved cursor to: " + string(cursor_q) + "," + string(cursor_r));
                }
            }
        }
        
        // Handle space key for selection/action (keeping original space functionality)
        if (keyboard_check_pressed(vk_space)) {
            var unit_at_cursor = get_unit_at(cursor_q, cursor_r);
            
            if (selected_unit == noone) {
                // If no unit is selected, try to select the unit at cursor
                if (unit_at_cursor != noone && unit_at_cursor.team == current_team && !unit_at_cursor.has_acted) {
                    scr_unit_select(unit_at_cursor);
                }
            } else {
                // If a unit is selected, try to perform an action (using new system)
                process_unit_action_input(selected_unit, cursor_q, cursor_r);
            }
        }
        
        // Handle escape key to deactivate cursor or cancel targeting
        if (keyboard_check_pressed(vk_escape)) {
            if (targeting_mode != TargetingMode.NONE) {
                cancel_targeting();
            } else {
                cursor_active = false;
                scr_clear_highlights();
                if (selected_unit != noone) {
                    if (!selected_unit.has_moved) {
                        calculate_movement_range(selected_unit);
                    } else if (!selected_unit.has_acted) {
                        calculate_attack_range(selected_unit);
                    }
                    obj_grid_manager.highlight_grid[selected_unit.grid_x][selected_unit.grid_y] = 3;
                }
            }
        }
        
        // Always update cursor highlight last
        obj_grid_manager.highlight_grid[cursor_q][cursor_r] = 4;
    }
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
    game_state = GameState.GAME_OVER;
}