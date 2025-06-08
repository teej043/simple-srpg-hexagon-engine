// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function is_target_in_attack_range(attacker, target_q, target_r) {
    /// Check if a target position is within attack range using flood fill
    /// @param {Id.Instance} attacker - The attacking unit
    /// @param {Real} target_q - Target hex Q coordinate  
    /// @param {Real} target_r - Target hex R coordinate
    /// @returns {Bool} True if target is within attack range
    
    // Quick bounds check
    if (!is_valid_position(target_q, target_r)) {
        return false;
    }
    
    with (obj_grid_manager) {
        // Initialize flood fill structures
        var queue = ds_queue_create();
        ds_queue_enqueue(queue, [attacker.grid_x, attacker.grid_y, 0]);
        
        var visited = array_create(grid_width);
        for (var i = 0; i < grid_width; i++) {
            visited[i] = array_create(grid_height, false);
        }
        visited[attacker.grid_x][attacker.grid_y] = true;

        var target_reachable = false;

        // Perform flood fill
        while (!ds_queue_empty(queue) && !target_reachable) {
            var current = ds_queue_dequeue(queue);
            var q = current[0];
            var r = current[1];
            var dist = current[2];
            
            // Check if we've reached the target position
            if (q == target_q && r == target_r && dist > 0) {
                target_reachable = true;
                break;
            }
            
            // Continue flood fill within attack range
            if (dist < attacker.attack_range) {
                var neighbors = get_hex_neighbors(q, r);
                for (var i = 0; i < array_length(neighbors); i++) {
                    var nq = neighbors[i][0];
                    var nr = neighbors[i][1];
                    
                    if (is_valid_position(nq, nr) && !visited[nq][nr]) {
                        visited[nq][nr] = true;
                        ds_queue_enqueue(queue, [nq, nr, dist + 1]);
                    }
                }
            }
        }
        
        // Cleanup
        ds_queue_destroy(queue);
        
        return target_reachable;
    }
} 