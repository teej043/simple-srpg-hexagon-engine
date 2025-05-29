/// @description Insert description here
// You can write your code in this editor

// Draw hexagonal grid
for (var q = 0; q < grid_width; q++) {
    for (var r = 0; r < grid_height; r++) {
        var pos = hex_to_pixel(q, r);
        var x_pos = pos[0];
        var y_pos = pos[1];
        
        // Set color based on highlight
        switch (highlight_grid[q][r]) {
            case 0: draw_set_color(c_gray); break;      // Normal
            case 1: draw_set_color(c_blue); break;      // Movement
            case 2: draw_set_color(c_red); break;       // Attack
            case 3: draw_set_color(c_green); break;     // Selected
            case 4: draw_set_color(c_yellow); break;    // Keyboard cursor
        }
        
        draw_set_alpha(0.3);
        draw_hexagon(x_pos, y_pos, hex_size, true);
        
        draw_set_color(c_white);
        draw_set_alpha(1);
        draw_hexagon(x_pos, y_pos, hex_size, false);
    }
}