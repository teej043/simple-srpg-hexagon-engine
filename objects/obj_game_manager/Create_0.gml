/// @description Insert description here
// You can write your code in this editor

// Initialize game state
current_team = 0; // 0 = player, 1 = enemy
turn_number = 1;
game_state = "playing"; // "playing", "game_over"

// Initialize unit lists
player_units = [];
enemy_units = [];

// Initialize selected unit
selected_unit = noone;

// Initialize cursor state
cursor_active = false;
cursor_q = 0;
cursor_r = 0;
cursor_move_timer = 0;
cursor_move_delay = 10;

// Initialize tab selection
can_tab_select = true;
tab_selection_index = 0;

// Initialize AI variables
ai_pending_unit = noone;
ai_pending_target = noone;

// Initialize game over state
game_over = false;
winner = -1; // -1 = no winner, 0 = player, 1 = enemy

// Action Panel UI
action_panel_open = false;
action_panel_selected_index = 0;
action_panel_actions = ["Spell", "Skill", "Wait"]; // Wait moved to bottom
action_panel_x = 0; // Will be set when panel opens
action_panel_y = 0; // Will be set when panel opens

/// @function scr_execute_action_panel_selection(action)
/// @description Execute the selected action from the action panel
/// @param {String} action - The selected action name
function scr_execute_action_panel_selection(action) {
    if (selected_unit == noone) return;
    
    switch(action) {
        case "Wait":
            scr_unit_wait(selected_unit);
            break;
            
        case "Spell":
            // TODO: Implement spell system
            show_debug_message("Spell system not implemented yet");
            break;
            
        case "Skill":
            // TODO: Implement skill system
            show_debug_message("Skill system not implemented yet");
            break;
            
        default:
            show_debug_message("Unknown action: " + action);
            break;
    }
}

// Initialize units
scr_game_initialize();