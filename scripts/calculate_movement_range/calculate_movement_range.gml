// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function calculate_movement_range(unit){
	/// Calculate valid movement positions for a unit
	/// @param {Id.Instance} unit - The unit to calculate movement for
	with (obj_grid_manager) {
    // Clear movement grid and only movement highlights (value 1), preserve attack highlights (value 2)
    for (var i = 0; i < grid_width; i++) {
        for (var j = 0; j < grid_height; j++) {
            movement_grid[i][j] = -1;
            if (highlight_grid[i][j] == 1) {
                highlight_grid[i][j] = 0;
            }
        }
    }

    // Flood fill algorithm for movement range
    var queue = ds_queue_create();
    ds_queue_enqueue(queue, [unit.grid_x, unit.grid_y, 0]);
    movement_grid[unit.grid_x][unit.grid_y] = 0;

    while (!ds_queue_empty(queue)) {
        var current = ds_queue_dequeue(queue);
        var q = current[0];
        var r = current[1];
        var dist = current[2];
        
        if (dist < unit.movement_range) {  // Changed from unit.speed
            var neighbors = get_hex_neighbors(q, r);
            for (var i = 0; i < array_length(neighbors); i++) {
                var nq = neighbors[i][0];
                var nr = neighbors[i][1];
                
                if (is_valid_position(nq, nr) && movement_grid[nq][nr] == -1) {
                    if (get_unit_at(nq, nr) == noone) {
                        movement_grid[nq][nr] = dist + 1;
                        // Only set movement highlight if there's no attack highlight
                        if (highlight_grid[nq][nr] != 2) {
                            highlight_grid[nq][nr] = 1; // Blue highlight for movement
                        }
                        ds_queue_enqueue(queue, [nq, nr, dist + 1]);
                    }
                }
            }
        }
    }

    ds_queue_destroy(queue);
    
    // Mark highlight surface for update
    highlight_needs_update = true;
}
}