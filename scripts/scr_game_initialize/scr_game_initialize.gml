// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/// Initialize the game with starting units
with (obj_game_manager) {
    show_debug_message("Initializing game...");
    
    // Calculate middle position horizontally (grid is 20 tiles wide)
    var start_x = floor((obj_grid_manager.grid_width - 5) / 2);  // Subtract 5 to center the group of 5 units
    
    // Define unit types for each team
    var player_unit_types = ["berserker", "mage", "darkknight", "grappler", "archer"];
    var enemy_unit_types = ["archer", "mage", "berserker", "darkknight", "grappler"];
    
    // Create player units
    for (var i = 0; i < 5; i++) {
        var unit_type = player_unit_types[i];
        var unit = create_unit_from_template(unit_type, start_x + i, 0, 0);
        
        if (unit != noone) {
            array_push(player_units, unit);
            show_debug_message("Player " + unit_type + " placed successfully at grid (" + 
                             string(start_x + i) + ",0)");
        } else {
            show_debug_message("Failed to create player " + unit_type + "!");
        }
    }

    // Create enemy units  
    var enemy_row = obj_grid_manager.grid_height - 1;
    for (var i = 0; i < 5; i++) {
        var unit_type = enemy_unit_types[i];
        var unit = create_unit_from_template(unit_type, start_x + i, enemy_row, 1);
        
        if (unit != noone) {
            unit.image_blend = c_red;  // Make enemy units red
            array_push(enemy_units, unit);
            show_debug_message("Enemy " + unit_type + " placed successfully at grid (" + 
                             string(start_x + i) + "," + string(enemy_row) + ")");
        } else {
            show_debug_message("Failed to create enemy " + unit_type + "!");
        }
    }
    
    show_debug_message("Game initialization complete. Player units: " + string(array_length(player_units)) + 
                      ", Enemy units: " + string(array_length(enemy_units)));
}