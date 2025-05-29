/// @description Insert description here
// You can write your code in this editor

// Enhanced Game State Management
enum GameState {
    WAITING_FOR_INPUT,    // Ready for player input
    PROCESSING_ACTION,    // An action is being processed/animated
    AI_THINKING,          // AI is deciding on actions
    TRANSITIONING,        // Between turns, checking win conditions
    GAME_OVER            // Game has ended
}

enum ACTION_TYPE {
    MOVE,
    ATTACK,
    CAST_SPELL,
    WAIT,
    USE_ITEM
}

enum TargetingMode {
    NONE,
    SINGLE_TARGET,       // Click one target
    AOE_RADIUS,          // Click center, affects radius
    AOE_LINE,            // Click direction, affects line
    SELF_ONLY            // No targeting needed
}

// Initialize enhanced game state
game_state = GameState.WAITING_FOR_INPUT;
current_team = 0; // 0 = player, 1 = enemy
turn_number = 1;
old_game_state = "playing"; // Keep for compatibility

// Action Queue System
action_queue = ds_queue_create();
current_action = noone;
action_in_progress = false;

// Initialize unit lists
player_units = [];
enemy_units = [];

// Initialize selected unit
selected_unit = noone;

// Targeting System
targeting_mode = TargetingMode.NONE;
pending_action_type = ACTION_TYPE.MOVE;
pending_spell_data = noone;

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

// Animation System
animation_in_progress = false;
current_sequence = noone;
sequence_callback = noone;

// Initialize game over state
game_over = false;
winner = -1; // -1 = no winner, 0 = player, 1 = enemy

// Initialize units
scr_game_initialize();