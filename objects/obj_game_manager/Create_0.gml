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