// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/// Initialize the game with starting units
with (obj_game_manager) {
    show_debug_message("Initializing game...");
    
    // Create player units
    for (var i = 0; i < 5; i++) {
        var unit = instance_create_layer(0, 0, "Units", obj_unit);
        unit.team = 0;
        
        show_debug_message("Placing player unit " + string(i) + " at grid (" + string(i) + ",0)");
        var success = place_unit_on_grid(unit, i, 0);
        if (success) {
            array_push(player_units, unit);
            show_debug_message("Player unit placed successfully at pixel (" + string(unit.x) + "," + string(unit.y) + ")");
        } else {
            show_debug_message("Failed to place player unit!");
            instance_destroy(unit);
        }
    }

    // Create enemy units  
    for (var i = 0; i < 5; i++) {
        var unit = instance_create_layer(0, 0, "Units", obj_unit);
        unit.team = 1;
        unit.image_blend = c_red;
        
        var enemy_row = obj_grid_manager.grid_height - 1;
        show_debug_message("Placing enemy unit " + string(i) + " at grid (" + string(i) + "," + string(enemy_row) + ")");
        var success = place_unit_on_grid(unit, i, enemy_row);
        if (success) {
            array_push(enemy_units, unit);
            show_debug_message("Enemy unit placed successfully at pixel (" + string(unit.x) + "," + string(unit.y) + ")");
        } else {
            show_debug_message("Failed to place enemy unit!");
            instance_destroy(unit);
        }
    }
    
    show_debug_message("Game initialization complete. Player units: " + string(array_length(player_units)) + 
                      ", Enemy units: " + string(array_length(enemy_units)));
}