// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function calculate_attack_range(unit){
	/// Calculate valid attack positions for a unit using flood fill
	/// @param {Id.Instance} unit - The unit to calculate attack range for
	with (obj_grid_manager) {
		// Preserve unit position highlight
		var unit_pos_highlight = highlight_grid[unit.grid_x][unit.grid_y];
		
		// Only clear attack highlights (value 2), preserve movement highlights (value 1)
		for (var i = 0; i < grid_width; i++) {
			for (var j = 0; j < grid_height; j++) {
				if (highlight_grid[i][j] == 2) {
					highlight_grid[i][j] = 0;
				}
			}
		}
		
		// Restore unit position highlight
		highlight_grid[unit.grid_x][unit.grid_y] = unit_pos_highlight;
		
		// Initialize flood fill structures
		var queue = ds_queue_create();
		ds_queue_enqueue(queue, [unit.grid_x, unit.grid_y, 0]);
		
		var visited = array_create(grid_width);
		for (var i = 0; i < grid_width; i++) {
			visited[i] = array_create(grid_height, false);
		}
		visited[unit.grid_x][unit.grid_y] = true;

		// Perform flood fill
		while (!ds_queue_empty(queue)) {
			var current = ds_queue_dequeue(queue);
			var q = current[0];
			var r = current[1];
			var dist = current[2];
			
			// Continue flood fill within attack range
			if (dist <= unit.attack_range) {
				// Mark attackable positions (excluding unit's own position)
				if (dist > 0) {
					// Only highlight positions with enemy units
					var target = get_unit_at(q, r);
					if (target != noone && target.team != unit.team) {
						highlight_grid[q][r] = 2; // Red highlight for attack
					}
				}
				
				// Add neighbors to queue
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
	}
}

