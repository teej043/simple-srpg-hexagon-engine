/// @description Insert description here
// You can write your code in this editor

// Unit stats
max_hp = 100;
current_hp = max_hp;
max_sp = 50;
current_sp = max_sp;
attack_power = 20;
defense = 10;
movement_range = 3; // Changed from 'speed' to avoid GameMaker's built-in movement

// Disable GameMaker's built-in movement system
speed = 0;           // No automatic movement
direction = 0;       // Reset direction
friction = 0;        // No friction
gravity = 0;         // No gravity

// Grid position (will be set by place_unit_on_grid)
grid_x = -1;  // Invalid position initially
grid_y = -1;

// Unit state
team = 0; // 0 = player, 1 = enemy
has_moved = false;
has_acted = false;
is_selected = false;

// Visual
sprite_index = spr_unit;
image_speed = 0;

// Action state
current_action = "none"; // "none", "moving", "attacking", "waiting"
target_x = 0;
target_y = 0;

