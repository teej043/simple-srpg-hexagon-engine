// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @description Action Manager - Handles action queue and state management
/// This system manages all unit actions, animations, and state transitions

/// Queue an action to be processed
/// @param {Struct} action_data - Action data structure
function queue_action(action_data) {
    with (obj_game_manager) {
        ds_queue_enqueue(action_queue, action_data);
        show_debug_message("[ACTION_QUEUE] Queued action: " + string(action_data.type) + " from " + string(action_data.unit.unit_type));
    }
}

/// Process the next action in queue
function process_next_action() {
    with (obj_game_manager) {
        if (action_in_progress || ds_queue_empty(action_queue)) {
            return false;
        }
        
        current_action = ds_queue_dequeue(action_queue);
        action_in_progress = true;
        game_state = GameState.PROCESSING_ACTION;
        
        show_debug_message("[ACTION_MANAGER] Processing: " + string(current_action.type));
        
        // Execute the action based on type
        switch(current_action.type) {
            case ACTION_TYPE.MOVE:
                execute_move_action(current_action);
                break;
                
            case ACTION_TYPE.ATTACK:
                execute_attack_action(current_action);
                break;
                
            case ACTION_TYPE.CAST_SPELL:
                execute_spell_action(current_action);
                break;
                
            case ACTION_TYPE.WAIT:
                execute_wait_action(current_action);
                break;
                
            default:
                show_debug_message("[ACTION_MANAGER] Unknown action type: " + string(current_action.type));
                complete_current_action();
                break;
        }
        
        return true;
    }
}

/// Complete the current action and continue processing
function complete_current_action() {
    with (obj_game_manager) {
        if (current_action != noone) {
            show_debug_message("[ACTION_MANAGER] Completed action: " + string(current_action.type));
            
            // Check if the unit that performed the action should be deselected
            var acting_unit = current_action.unit;
            if (instance_exists(acting_unit)) {
                // If the unit has completed all possible actions, deselect them
                if (acting_unit.has_moved && acting_unit.has_acted) {
                    show_debug_message("[ACTION_MANAGER] Unit has completed all actions, deselecting");
                    scr_unit_deselect(acting_unit);
                } else {
                    // If unit still has actions available, update their highlights
                    if (selected_unit == acting_unit) {
                        scr_clear_highlights();
                        
                        // Show available actions
                        if (!acting_unit.has_moved) {
                            calculate_movement_range(acting_unit);
                        } else if (!acting_unit.has_acted) {
                            calculate_attack_range(acting_unit);
                        }
                        
                        // Keep unit highlighted
                        obj_grid_manager.highlight_grid[acting_unit.grid_x][acting_unit.grid_y] = 3;
                    }
                }
            } else {
                // Unit was destroyed during the action (e.g., counterattack), clear selection
                show_debug_message("[ACTION_MANAGER] Acting unit was destroyed, clearing selection");
                if (selected_unit == current_action.unit) {
                    selected_unit = noone;
                    scr_clear_highlights();
                }
            }
            
            current_action = noone;
        }
        
        action_in_progress = false;
        animation_in_progress = false;
        
        // Process next action or return to input state
        if (!process_next_action()) {
            if (current_team == 0) {
                game_state = GameState.WAITING_FOR_INPUT;
            } else {
                game_state = GameState.AI_THINKING;
                // Continue AI processing
                alarm[0] = 10; // Small delay before next AI action
            }
        }
    }
}

/// Check if the game can accept input
/// @return {Bool} - True if input should be processed
function can_accept_input() {
    with (obj_game_manager) {
        var can_accept = (game_state == GameState.WAITING_FOR_INPUT && 
                         current_team == 0 && 
                         !action_in_progress &&
                         !animation_in_progress);
        
        return can_accept;
    }
}

/// Log why input is blocked (call this only when input is actually attempted)
function log_input_blocked_reason() {
    with (obj_game_manager) {
        var debug_msg = "[INPUT_BLOCKED] ";
        if (game_state != GameState.WAITING_FOR_INPUT) {
            debug_msg += "Wrong game state: " + string(game_state) + " ";
        }
        if (current_team != 0) {
            debug_msg += "Not player turn: " + string(current_team) + " ";
        }
        if (action_in_progress) {
            debug_msg += "Action in progress ";
        }
        if (animation_in_progress) {
            debug_msg += "Animation in progress ";
        }
        show_debug_message(debug_msg);
    }
}

/// Start targeting mode for an action
/// @param {Real} action_type - The ACTION_TYPE enum
/// @param {Real} targeting_mode - The TargetingMode enum  
/// @param {Struct} spell_data - Optional spell data for casting
function start_targeting(action_type, target_mode, spell_data = noone) {
    with (obj_game_manager) {
        targeting_mode = target_mode;
        pending_action_type = action_type;
        pending_spell_data = spell_data;
        
        show_debug_message("[TARGETING] Started targeting mode: " + string(target_mode) + " for action: " + string(action_type));
    }
}

/// Cancel current targeting
function cancel_targeting() {
    with (obj_game_manager) {
        targeting_mode = TargetingMode.NONE;
        pending_action_type = ACTION_TYPE.MOVE;
        pending_spell_data = noone;
        
        // Clear any targeting highlights
        scr_clear_highlights();
        
        // Restore unit selection highlights if we have a selected unit
        if (selected_unit != noone) {
            scr_unit_select(selected_unit);
        }
        
        show_debug_message("[TARGETING] Cancelled targeting");
    }
}

/// Execute move action (integrates with existing movement system)
/// @param {Struct} action - Move action data
function execute_move_action(action) {
    var unit = action.unit;
    var target_q = action.target_x;
    var target_r = action.target_y;
    
    show_debug_message("[MOVE_ACTION] " + unit.unit_type + " moving to [" + string(target_q) + "," + string(target_r) + "]");
    
    // Use existing movement system but with callback
    // Set up movement path (copying from scr_unit_handle_action)
    ds_list_clear(unit.movement_path);
    
    var current_q = target_q;
    var current_r = target_r;
    ds_list_add(unit.movement_path, [current_q, current_r]);
    
    // Build path using existing logic
    var max_iterations = unit.movement_range * 2;
    var iterations = 0;
    
    while (current_q != unit.grid_x || current_r != unit.grid_y) {
        iterations++;
        if (iterations > max_iterations) {
            show_debug_message("[MOVE_ACTION] Pathfinding failed!");
            complete_current_action();
            return;
        }
        
        var found_next = false;
        var current_value = obj_grid_manager.movement_grid[current_q][current_r];
        
        with (obj_grid_manager) {
            var directions = get_hex_directions(current_r);
            for (var i = 0; i < array_length(directions); i++) {
                var check_q = current_q + directions[i][0];
                var check_r = current_r + directions[i][1];
                
                if (is_valid_position(check_q, check_r)) {
                    if (movement_grid[check_q][check_r] == current_value - 1) {
                        current_q = check_q;
                        current_r = check_r;
                        ds_list_insert(unit.movement_path, 0, [current_q, current_r]);
                        found_next = true;
                        break;
                    }
                }
            }
        }
        
        if (!found_next) {
            show_debug_message("[MOVE_ACTION] Pathfinding failed - no next step found!");
            complete_current_action();
            return;
        }
    }
    
    // Start movement animation
    unit.is_moving = true;
    unit.current_path_position = 0;
    unit.move_progress = 0;
    unit.has_moved = true;
    remove_unit_from_grid(unit);
    
    // The movement will complete naturally and call complete_current_action when done
    // We'll modify obj_unit's movement completion to call this
}

/// Execute attack action (placeholder for now)
/// @param {Struct} action - Attack action data  
function execute_attack_action(action) {
    var attacker = action.unit;
    var target = action.target_unit;
    
    show_debug_message("[ATTACK_ACTION] " + attacker.unit_type + " attacking " + target.unit_type);
    
    // For now, use existing instant attack
    execute_attack(attacker, target);
    
    // TODO: Replace with animated attack sequence
    complete_current_action();
}

/// Execute spell action (placeholder)
/// @param {Struct} action - Spell action data
function execute_spell_action(action) {
    show_debug_message("[SPELL_ACTION] Casting spell (not implemented yet)");
    complete_current_action();
}

/// Execute wait action
/// @param {Struct} action - Wait action data
function execute_wait_action(action) {
    var unit = action.unit;
    show_debug_message("[WAIT_ACTION] " + unit.unit_type + " waiting");
    
    scr_unit_wait(unit);
    complete_current_action();
}

/// Create move action data
/// @param {Id.Instance} unit - Unit to move
/// @param {Real} target_q - Target Q coordinate
/// @param {Real} target_r - Target R coordinate
/// @return {Struct} - Move action data
function create_move_action(unit, target_q, target_r) {
    return {
        type: ACTION_TYPE.MOVE,
        unit: unit,
        target_x: target_q,
        target_y: target_r
    };
}

/// Create attack action data
/// @param {Id.Instance} attacker - Attacking unit
/// @param {Id.Instance} target - Target unit
/// @return {Struct} - Attack action data
function create_attack_action(attacker, target) {
    return {
        type: ACTION_TYPE.ATTACK,
        unit: attacker,
        target_unit: target,
        target_x: target.grid_x,
        target_y: target.grid_y
    };
}

/// Create spell action data
/// @param {Id.Instance} caster - Casting unit
/// @param {Struct} spell_data - Spell information
/// @param {Real} target_q - Target Q coordinate
/// @param {Real} target_r - Target R coordinate
/// @param {Array} affected_targets - Array of affected units (for AOE)
/// @return {Struct} - Spell action data
function create_spell_action(caster, spell_data, target_q, target_r, affected_targets = []) {
    return {
        type: ACTION_TYPE.CAST_SPELL,
        unit: caster,
        spell_data: spell_data,
        target_x: target_q,
        target_y: target_r,
        affected_targets: affected_targets
    };
}

/// Create wait action data
/// @param {Id.Instance} unit - Unit to wait
/// @return {Struct} - Wait action data
function create_wait_action(unit) {
    return {
        type: ACTION_TYPE.WAIT,
        unit: unit
    };
}

/// Skip current animation (for space key functionality)
function skip_current_animation() {
    with (obj_game_manager) {
        if (action_in_progress && current_action != noone) {
            switch(current_action.type) {
                case ACTION_TYPE.MOVE:
                    // Skip movement animation
                    if (instance_exists(current_action.unit) && current_action.unit.is_moving) {
                        current_action.unit.skip_animation = true;
                    }
                    break;
                    
                case ACTION_TYPE.ATTACK:
                    // Skip attack animation (when implemented)
                    // For now, complete immediately
                    complete_current_action();
                    break;
                    
                case ACTION_TYPE.CAST_SPELL:
                    // Skip spell animation (when implemented)
                    complete_current_action();
                    break;
            }
        }
    }
}

/// Process pending turn actions (called when input determines an action should happen)
/// @param {Id.Instance} unit - The acting unit
/// @param {Real} target_q - Target Q coordinate  
/// @param {Real} target_r - Target R coordinate
function process_unit_action_input(unit, target_q, target_r) {
    with (obj_game_manager) {
        // Check what type of action this should be based on targeting mode and target
        var target_unit = get_unit_at(target_q, target_r);
        
        switch(targeting_mode) {
            case TargetingMode.NONE:
                // Default behavior - determine action based on what the player clicked
                
                // FIRST: Check if clicking on an enemy unit for attack
                if (target_unit != noone && target_unit.team != unit.team && !unit.has_acted) {
                    // Attack action
                    if (is_target_in_attack_range(unit, target_q, target_r)) {
                        show_debug_message("[ACTION_INPUT] Attack action: " + unit.unit_type + " attacking " + target_unit.unit_type);
                        var attack_action = create_attack_action(unit, target_unit);
                        queue_action(attack_action);
                        process_next_action();
                        return true;
                    } else {
                        show_debug_message("[ACTION_INPUT] Enemy target out of attack range");
                        return false;
                    }
                }
                
                // SECOND: Check if clicking on empty space for movement
                if (target_unit == noone && !unit.has_moved) {
                    // Movement action - check if target is a valid movement tile
                    if (is_valid_position(target_q, target_r) && obj_grid_manager.highlight_grid[target_q][target_r] == 1) {
                        show_debug_message("[ACTION_INPUT] Move action: " + unit.unit_type + " moving to [" + string(target_q) + "," + string(target_r) + "]");
                        var move_action = create_move_action(unit, target_q, target_r);
                        queue_action(move_action);
                        process_next_action();
                        return true;
                    } else {
                        show_debug_message("[ACTION_INPUT] Invalid movement target - highlight value: " + string(obj_grid_manager.highlight_grid[target_q][target_r]));
                        return false;
                    }
                }
                
                // THIRD: Check if clicking on friendly unit for selection (unit selection happens in calling code)
                if (target_unit != noone && target_unit.team == unit.team) {
                    show_debug_message("[ACTION_INPUT] Friendly unit clicked - selection handled elsewhere");
                    return false; // Let the calling code handle unit selection
                }
                
                // No valid action found
                show_debug_message("[ACTION_INPUT] No valid action found. Target unit: " + string(target_unit) + 
                                 ", Unit has_moved: " + string(unit.has_moved) + 
                                 ", Unit has_acted: " + string(unit.has_acted));
                return false;
                
            case TargetingMode.SINGLE_TARGET:
                // Spell targeting - single target
                if (pending_action_type == ACTION_TYPE.CAST_SPELL) {
                    var spell_action = create_spell_action(unit, pending_spell_data, target_q, target_r, [target_unit]);
                    queue_action(spell_action);
                    cancel_targeting();
                    process_next_action();
                    return true;
                }
                break;
                
            case TargetingMode.AOE_RADIUS:
                // AOE spell targeting
                if (pending_action_type == ACTION_TYPE.CAST_SPELL) {
                    // Calculate affected targets in radius
                    var affected = calculate_aoe_targets(target_q, target_r, pending_spell_data.radius);
                    var spell_action = create_spell_action(unit, pending_spell_data, target_q, target_r, affected);
                    queue_action(spell_action);
                    cancel_targeting();
                    process_next_action();
                    return true;
                }
                break;
                
            case TargetingMode.AOE_LINE:
                // Line spell targeting  
                if (pending_action_type == ACTION_TYPE.CAST_SPELL) {
                    var affected = calculate_line_targets(unit.grid_x, unit.grid_y, target_q, target_r, pending_spell_data.range);
                    var spell_action = create_spell_action(unit, pending_spell_data, target_q, target_r, affected);
                    queue_action(spell_action);
                    cancel_targeting();
                    process_next_action();
                    return true;
                }
                break;
        }
        
        return false; // No valid action processed
    }
}

/// Placeholder functions for AOE calculations (to be implemented with spell system)
/// @param {Real} center_q - Center Q coordinate
/// @param {Real} center_r - Center R coordinate  
/// @param {Real} radius - Effect radius
/// @return {Array} - Array of affected units
function calculate_aoe_targets(center_q, center_r, radius) {
    // TODO: Implement AOE target calculation
    return [];
}

/// @param {Real} start_q - Starting Q coordinate
/// @param {Real} start_r - Starting R coordinate
/// @param {Real} end_q - Ending Q coordinate
/// @param {Real} end_r - Ending R coordinate
/// @param {Real} range - Maximum range
/// @return {Array} - Array of affected units
function calculate_line_targets(start_q, start_r, end_q, end_r, range) {
    // TODO: Implement line target calculation
    return [];
} 