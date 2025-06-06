        var found_next = false;
        var current_value = obj_grid_manager.movement_grid[current_q][current_r];
        var best_neighbor_cost = 999;
        var best_neighbor_q = -1;
        var best_neighbor_r = -1;
        
        with (obj_grid_manager) {
            var directions = get_hex_directions(current_r);
            for (var i = 0; i < array_length(directions); i++) {
                var check_q = current_q + directions[i][0];
                var check_r = current_r + directions[i][1];
                
                if (is_valid_position(check_q, check_r)) {
                    var neighbor_cost = movement_grid[check_q][check_r];
                    // Look for the neighbor with the lowest cost that's less than current
                    if (neighbor_cost >= 0 && neighbor_cost < current_value && neighbor_cost < best_neighbor_cost) {
                        best_neighbor_cost = neighbor_cost;
                        best_neighbor_q = check_q;
                        best_neighbor_r = check_r;
                        found_next = true;
                    }
                }
            }
        }
        
        if (found_next) {
            current_q = best_neighbor_q;
            current_r = best_neighbor_r;
            ds_list_insert(unit.movement_path, 0, [current_q, current_r]);
        } 