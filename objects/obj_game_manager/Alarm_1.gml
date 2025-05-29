/// @description Insert description here
// You can write your code in this editor

/// @description Check for post-movement AI attack
// If we have a pending AI unit and target
if (ai_pending_unit != noone && ai_pending_target != noone) {
    // Check if both unit and target still exist
    if (!instance_exists(ai_pending_unit) || !instance_exists(ai_pending_target)) {
        // Clean up and exit if either doesn't exist
        ai_pending_unit = noone;
        ai_pending_target = noone;
        return;
    }
    
    // Only proceed if the unit has finished moving
    if (!ai_pending_unit.is_moving) {
        var can_attack = false;
        
        // Store references to avoid scope issues
        var unit = ai_pending_unit;
        var target = ai_pending_target;
        
        show_debug_message("\n=== AI POST-MOVEMENT CHECK ===");
        show_debug_message("[AI] " + unit.unit_type + " checking for attack after moving");
        
        // Use the same flood fill algorithm as attack range visualization
        var can_attack = is_target_in_attack_range(unit, target.grid_x, target.grid_y);
        
        if (can_attack) {
            show_debug_message("[AI] Target is within attack range!");
        }
        
        // If we can attack after moving, do it
        if (can_attack && !unit.has_acted) {
            show_debug_message("[AI] Executing post-movement attack");
            execute_attack(unit, target);
            unit.has_acted = true;
            scr_unit_deselect(unit);
        } else {
            // If we can't attack, just end the unit's turn
            show_debug_message("[AI] Cannot attack after movement, ending turn");
            scr_unit_wait(unit);
        }
        
        show_debug_message("=== AI POST-MOVEMENT CHECK END ===\n");
        
        // Clear pending unit and target
        ai_pending_unit = noone;
        ai_pending_target = noone;
    } else {
        // Unit is still moving, check again next step
        alarm[1] = 1;
    }
}
