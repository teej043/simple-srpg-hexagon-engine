/// @description Insert description here
// You can write your code in this editor


event_inherited();

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

// Movement animation variables
movement_path = ds_list_create(); // List to store path coordinates
current_path_position = 0;        // Current position in the path
is_moving = false;               // Whether unit is currently moving
move_progress = 0;              // Progress between current and next hex (0-1)
move_speed = 0.1;              // How fast to move between hexes (adjust as needed)
skip_animation = false;         // Flag to skip movement animation

// Actual pixel position for smooth movement
actual_x = 0;
actual_y = 0;

// Unit state
team = 0; // 0 = player, 1 = enemy
has_moved = false;
has_acted = false;
is_selected = false;

// Visual settings
sprite_index = choose(spr_berserker_idle, spr_mage_idle, spr_darkknight_idle, spr_grappler_idle, spr_archer_idle);
image_speed = 0;    // Disable sprite animation
image_index = 0;    // Start with front-facing sprite
image_xscale = 1;   // Start facing right

// Action state
current_action = "none"; // "none", "moving", "attacking", "waiting"
target_x = 0;
target_y = 0;

