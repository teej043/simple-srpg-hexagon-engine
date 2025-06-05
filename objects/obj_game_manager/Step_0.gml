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

// Debug check for enter key at global level
if (keyboard_check_pressed(vk_enter) && DEBUG) {
    show_debug_message("=== ENTER KEY DETECTED (global check) ===");
    show_debug_message("Current team: " + string(current_team));
    show_debug_message("Any unit moving: " + string(any_unit_moving));
    show_debug_message("Cursor active: " + string(cursor_active));
}

if (keyboard_check_pressed(vk_space) && current_team == 0 && !any_unit_moving) {
    scr_game_end_turn();
}

// Handle tab selection for player units
if (current_team == 0 && !any_unit_moving) {  // Only during player's turn and when no unit is moving
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
            
            // Clear any existing highlights
            scr_clear_highlights();
            
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

// Handle keyboard cursor
if (current_team == 0 && !any_unit_moving) {  // Only during player's turn and when no unit is moving
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
        
        // Initial highlight setup when cursor becomes active
        scr_clear_highlights();
        // If there's a selected unit, show its ranges
        if (selected_unit != noone) {
            if (!selected_unit.has_moved) {
                calculate_movement_range(selected_unit);
            } else if (!selected_unit.has_acted) {
                calculate_attack_range(selected_unit);
            }
            obj_grid_manager.highlight_grid[selected_unit.grid_x][selected_unit.grid_y] = 3;
        }
        // Set initial cursor highlight
        obj_grid_manager.highlight_grid[cursor_q][cursor_r] = 4;
        obj_grid_manager.highlight_needs_update = true;
    }
    
    if (cursor_active) {
        // Handle cursor movement with delay
        if (cursor_move_timer <= 0) {
            var moved = false;
            var old_cursor_q = cursor_q;
            var old_cursor_r = cursor_r;
            
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
            
            // Only update highlights if cursor actually moved
            if (moved) {
                // Instead of trying to restore individual highlights, 
                // refresh the entire highlight state efficiently
                scr_clear_highlights();
                
                // Restore range highlights if there's a selected unit
                if (selected_unit != noone) {
                    if (!selected_unit.has_moved) {
                        calculate_movement_range(selected_unit);
                    } else if (!selected_unit.has_acted) {
                        calculate_attack_range(selected_unit);
                    }
                    obj_grid_manager.highlight_grid[selected_unit.grid_x][selected_unit.grid_y] = 3;
                }
                
                // Set new cursor highlight
                obj_grid_manager.highlight_grid[cursor_q][cursor_r] = 4;
                cursor_move_timer = cursor_move_delay;
            }
        } else {
            cursor_move_timer--;
        }
        
        // Handle enter key for selection/action (like left mouse button)
        if (keyboard_check_pressed(vk_enter)) {
            if (DEBUG) {
                show_debug_message("=== ENTER KEY PRESSED ===");
                show_debug_message("Cursor position: [" + string(cursor_q) + "," + string(cursor_r) + "]");
                show_debug_message("Cursor active: " + string(cursor_active));
                show_debug_message("Selected unit: " + string(selected_unit));
            }
            
            // First check if we have a selected unit
            if (selected_unit != noone) {
                if (DEBUG) {
                    show_debug_message("Checking action with selected unit at: [" + string(selected_unit.grid_x) + "," + string(selected_unit.grid_y) + "]");
                    show_debug_message("Unit has_moved: " + string(selected_unit.has_moved) + ", has_acted: " + string(selected_unit.has_acted));
                }
                
                // Check if there's an enemy unit at the cursor position for attack
                var unit_at_cursor = get_unit_at(cursor_q, cursor_r);
                if (DEBUG) {
                    show_debug_message("Unit at cursor position: " + string(unit_at_cursor));
                    if (unit_at_cursor != noone) {
                        show_debug_message("Unit team: " + string(unit_at_cursor.team) + " vs selected unit team: " + string(selected_unit.team));
                    }
                }
                
                if (unit_at_cursor != noone && unit_at_cursor.team != selected_unit.team && !selected_unit.has_acted) {
                    if (DEBUG) {
                        show_debug_message("Found enemy unit, checking attack range...");
                    }
                    // Use the same flood fill algorithm as attack range visualization
                    var can_attack = is_target_in_attack_range(selected_unit, cursor_q, cursor_r);
                    
                    if (can_attack) {
                        if (DEBUG) {
                            show_debug_message("Valid attack target found, performing attack");
                        }
                        scr_unit_handle_action(selected_unit, cursor_q, cursor_r);
                        exit;
                    } else {
                        if (DEBUG) {
                            show_debug_message("Enemy unit found but not in attack range");
                        }
                    }
                }
                
                // If no attack was possible, check for movement
                // We need to check movement range differently since cursor highlight (4) overwrites movement highlight (1)
                if (!selected_unit.has_moved) {
                    // First check bounds to avoid array access errors
                    if (cursor_q >= 0 && cursor_q < obj_grid_manager.grid_width && 
                        cursor_r >= 0 && cursor_r < obj_grid_manager.grid_height) {
                        
                        // Check if cursor position is reachable by looking at the movement grid
                        // movement_grid stores the movement cost to reach each position (-1 means unreachable)
                        var movement_cost = obj_grid_manager.movement_grid[cursor_q][cursor_r];
                        if (DEBUG) {
                            show_debug_message("Movement cost to cursor position [" + string(cursor_q) + "," + string(cursor_r) + "]: " + string(movement_cost));
                            show_debug_message("Unit at cursor: " + string(unit_at_cursor));
                        }
                        if (movement_cost != -1 && movement_cost > 0) {
                            // Also check if the position is empty (no unit there)
                            if (unit_at_cursor == noone) {
                                if (DEBUG) {
                                    show_debug_message("Valid movement target found, performing move (cost: " + string(movement_cost) + ")");
                                }
                                scr_unit_handle_action(selected_unit, cursor_q, cursor_r);
                                exit;
                            } else {
                                if (DEBUG) {
                                    show_debug_message("Cannot move - position occupied by unit: " + string(unit_at_cursor));
                                }
                            }
                        } else {
                            if (DEBUG) {
                                show_debug_message("Cannot move - position not in movement range (cost: " + string(movement_cost) + ")");
                            }
                        }
                    } else {
                        if (DEBUG) {
                            show_debug_message("Cannot move - cursor position out of bounds");
                        }
                    }
                } else {
                    if (DEBUG) {
                        show_debug_message("Unit has already moved this turn");
                    }
                }
            }
            
            // If no action was performed, try to select a unit
            var unit_at_cursor = get_unit_at(cursor_q, cursor_r);
            if (DEBUG) {
                show_debug_message("Checking for unit selection. Unit at cursor: " + string(unit_at_cursor));
            }
            
            if (unit_at_cursor != noone && unit_at_cursor.team == current_team && !unit_at_cursor.has_acted) {
                if (DEBUG) {
                    show_debug_message("Found valid player unit to select");
                }
                if (unit_at_cursor != selected_unit) {
                    scr_unit_select(unit_at_cursor);
                    // Reset cursor position to the newly selected unit
                    cursor_q = unit_at_cursor.grid_x;
                    cursor_r = unit_at_cursor.grid_y;
                    // Update cursor highlight (scr_unit_select already triggers highlight update)
                    obj_grid_manager.highlight_grid[cursor_q][cursor_r] = 4;
                    if (DEBUG) {
                        show_debug_message("Selected new unit and moved cursor to: " + string(cursor_q) + "," + string(cursor_r));
                    }
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
                    // Update cursor highlight (scr_unit_select already triggers highlight update)
                    obj_grid_manager.highlight_grid[cursor_q][cursor_r] = 4;
                }
            } else {
                // If a unit is selected, try to perform an action
                scr_unit_handle_action(selected_unit, cursor_q, cursor_r);
            }
        }
        
        // Handle escape key to deactivate cursor
        if (keyboard_check_pressed(vk_escape)) {
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