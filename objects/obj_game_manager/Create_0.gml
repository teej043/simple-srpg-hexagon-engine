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

// Initialize units
scr_game_initialize();