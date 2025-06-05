/// @description Insert description here
// You can write your code in this editor
depth = -y;
// Handle movement animation
if (is_moving) {
    if (skip_animation) {
        if (DEBUG) {
            show_debug_message("=== SKIPPING ANIMATION ===");
        }
        var final_pos = ds_list_find_value(movement_path, ds_list_size(movement_path) - 1);
        var start_pos = ds_list_find_value(movement_path, 0);
        
        // Set facing direction based on total movement
        var total_dx = final_pos[0] - start_pos[0];
        var total_dy = final_pos[1] - start_pos[1];
        
        // Prioritize the most significant direction change
        if (abs(total_dx) >= abs(total_dy)) {
            image_xscale = (total_dx > 0) ? 1 : -1;
            image_index = 0; // Front facing for horizontal movement
        } else {
            image_xscale = 1; // Reset horizontal flip
            image_index = (total_dy < 0) ? 1 : 0; // Back facing for up, front for down
        }
        
        grid_x = final_pos[0];
        grid_y = final_pos[1];
        var final_pixel = hex_to_pixel(grid_x, grid_y);
        actual_x = final_pixel[0];
        actual_y = final_pixel[1];
        x = actual_x;
        y = actual_y;
        is_moving = false;
        has_moved = true;
        
        if (DEBUG) {
            show_debug_message("Skipped to final position: Grid[" + string(grid_x) + "," + string(grid_y) + 
                              "] Pixel[" + string(actual_x) + "," + string(actual_y) + "]");
            show_debug_message("Final facing direction: xscale=" + string(image_xscale) + ", index=" + string(image_index));
        }
        
        // Place unit back on grid at final position
        place_unit_on_grid(id, grid_x, grid_y);
        
        // Clear movement path and reset animation variables
        ds_list_clear(movement_path);
        move_progress = 0;
        current_path_position = 0;
        skip_animation = false;
        
        // Show attack range if unit hasn't acted yet
        if (!has_acted) {
            scr_clear_highlights();
            calculate_attack_range(id);
            obj_grid_manager.highlight_grid[grid_x][grid_y] = 3; // Keep unit highlighted
        }
    }
    else {
        // Log the entire movement path at the start of movement
        if (current_path_position == 0 && move_progress == 0) {
            if (DEBUG) {
                show_debug_message("=== MOVEMENT PATH START ===");
                for (var i = 0; i < ds_list_size(movement_path); i++) {
                    var pos = ds_list_find_value(movement_path, i);
                    show_debug_message("Path position " + string(i) + ": [" + string(pos[0]) + "," + string(pos[1]) + "]");
                }
                show_debug_message("=== MOVEMENT PATH END ===");
            }
        }

        if (current_path_position < ds_list_size(movement_path) - 1) {
            // Get current and next positions from the path
            var current_pos = ds_list_find_value(movement_path, current_path_position);
            var next_pos = ds_list_find_value(movement_path, current_path_position + 1);
            
            // Log current movement state
            if (DEBUG) {
                show_debug_message("Moving from [" + string(current_pos[0]) + "," + string(current_pos[1]) + 
                                 "] to [" + string(next_pos[0]) + "," + string(next_pos[1]) + 
                                 "] Progress: " + string(move_progress));
            }
            
            // Convert hex coordinates to pixel positions
            var current_pixel = hex_to_pixel(current_pos[0], current_pos[1]);
            var next_pixel = hex_to_pixel(next_pos[0], next_pos[1]);
            
            // Update actual position
            actual_x = lerp(current_pixel[0], next_pixel[0], move_progress);
            actual_y = lerp(current_pixel[1], next_pixel[1], move_progress);
            x = actual_x;
            y = actual_y;
            
            if (DEBUG) {
                show_debug_message("Current pixel position: [" + string(actual_x) + "," + string(actual_y) + "]");
            }
            
            // Interpolate between positions
            move_progress += move_speed;
            if (move_progress >= 1) {
                // When reaching next position, snap to exact pixel position
                actual_x = next_pixel[0];
                actual_y = next_pixel[1];
                x = actual_x;
                y = actual_y;
                
                move_progress = 0;
                current_path_position++;
                
                // Update grid position
                grid_x = next_pos[0];
                grid_y = next_pos[1];
                
                // Update facing direction based on movement
                var dx = next_pos[0] - current_pos[0];
                var dy = next_pos[1] - current_pos[1];
                
                // Determine horizontal facing (left/right)
                if (dx != 0) {
                    image_xscale = (dx > 0) ? 1 : -1;
                }
                
                // Determine vertical facing (front/back)
                if (dy != 0) {
                    image_index = (dy < 0) ? 1 : 0; // 1 for back (facing north), 0 for front (facing south)
                }
                
                if (DEBUG) {
                    show_debug_message("Reached next position. Grid position now: [" + string(grid_x) + "," + string(grid_y) + "]");
                    show_debug_message("Snapped to pixel position: [" + string(actual_x) + "," + string(actual_y) + "]");
                    show_debug_message("Facing direction: xscale=" + string(image_xscale) + ", index=" + string(image_index));
                }
                
                // Check if we've reached the end of the path
                if (current_path_position >= ds_list_size(movement_path) - 1) {
                    is_moving = false;
                    has_moved = true;
                    
                    // Ensure final position is correct
                    var final_pos = ds_list_find_value(movement_path, ds_list_size(movement_path) - 1);
                    grid_x = final_pos[0];
                    grid_y = final_pos[1];
                    var final_pixel = hex_to_pixel(grid_x, grid_y);
                    actual_x = final_pixel[0];
                    actual_y = final_pixel[1];
                    x = actual_x;
                    y = actual_y;
                    
                    // Set final facing direction based on total movement
                    var start_pos = ds_list_find_value(movement_path, 0);
                    var total_dx = final_pos[0] - start_pos[0];
                    var total_dy = final_pos[1] - start_pos[1];
                    
                    // Prioritize the most significant direction change
                    if (abs(total_dx) >= abs(total_dy)) {
                        image_xscale = (total_dx > 0) ? 1 : -1;
                        image_index = 0; // Front facing for horizontal movement
                    } else {
                        image_xscale = 1; // Reset horizontal flip
                        image_index = (total_dy < 0) ? 1 : 0; // Back facing for up, front for down
                    }
                    
                    if (DEBUG) {
                        show_debug_message("=== MOVEMENT COMPLETE ===");
                        show_debug_message("Final grid position: [" + string(grid_x) + "," + string(grid_y) + "]");
                        show_debug_message("Final pixel position: [" + string(actual_x) + "," + string(actual_y) + "]");
                        show_debug_message("Final facing direction: xscale=" + string(image_xscale) + ", index=" + string(image_index));
                    }
                    
                    // Place unit back on grid at final position
                    place_unit_on_grid(id, grid_x, grid_y);
                    
                    ds_list_clear(movement_path);
                    move_progress = 0;
                    current_path_position = 0;
                    skip_animation = false;
                    
                    // Show attack range if unit hasn't acted yet
                    if (!has_acted) {
                        scr_clear_highlights();
                        calculate_attack_range(id);
                        obj_grid_manager.highlight_grid[grid_x][grid_y] = 3; // Keep unit highlighted
                    }
                }
            }
        }
    }
}

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

// Space to skip animation
if (keyboard_check_pressed(vk_space) && is_moving) {
    skip_animation = true;
}