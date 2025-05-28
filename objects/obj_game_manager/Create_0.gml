/// @description Insert description here
// You can write your code in this editor

// Turn management
current_team = 0;
turn_number = 1;
game_state = "playing"; // "playing", "game_over"

// Selected unit reference
selected_unit = noone;

// Unit lists
player_units = [];
enemy_units = [];

// Initialize units
scr_game_initialize();

// Tab selection variables
tab_selection_index = 0;  // Current index in the player units array when using tab
can_tab_select = true;    // Flag to control tab selection timing

// Keyboard cursor variables
cursor_q = 0;  // Cursor position in hex grid (q coordinate)
cursor_r = 0;  // Cursor position in hex grid (r coordinate)
cursor_active = false;  // Whether the keyboard cursor is currently active
cursor_move_delay = 10;  // Delay between cursor movements (in steps)
cursor_move_timer = 0;   // Timer for cursor movement