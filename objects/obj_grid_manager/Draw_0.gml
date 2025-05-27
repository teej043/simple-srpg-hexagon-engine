/// @description Draw the hex grid in 3D

// Draw hexagonal grid
for (var q = 0; q < grid_width; q++) {
    for (var r = 0; r < grid_height; r++) {
        var pos = hex_to_pixel(q, r);
        var x_pos = pos[0];
        var y_pos = pos[1];
        var z_pos = base_z + terrain_height[q][r];
        
        // Set color based on highlight
        var hex_color;
        switch (highlight_grid[q][r]) {
            case 0: hex_color = c_gray; break;      // Normal
            case 1: hex_color = c_blue; break;      // Movement
            case 2: hex_color = c_red; break;       // Attack
            case 3: hex_color = c_green; break;     // Selected
            default: hex_color = c_gray; break;
        }
        
        // Draw filled hex with transparency
        draw_set_alpha(0.3);
        draw_hexagon_3d(x_pos, y_pos, z_pos, hex_size * 0.95, hex_depth, true, hex_color);
        
        // Draw outline
        draw_set_alpha(1);
        draw_hexagon_3d(x_pos, y_pos, z_pos, hex_size, hex_depth, false, c_white);
    }
}

// Reset alpha
draw_set_alpha(1);