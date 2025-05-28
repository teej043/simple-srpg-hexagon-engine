/// @description Draw hexagonal grid with height effect
// You can write your code in this editor

// Draw hexagonal grid
for (var q = 0; q < grid_width; q++) {
    for (var r = 0; r < grid_height; r++) {
        var pos = hex_to_pixel(q, r);
        var x_pos = pos[0];
        var y_pos = pos[1];
        
        // Set color based on highlight with height effect
        var height_value = 0;
        switch (highlight_grid[q][r]) {
            case 0: // Normal
                draw_set_color(make_color_rgb(8, 8, 8)); 
                height_value = 8;
                break;
            case 1: // Movement
                draw_set_color(make_color_rgb(16, 0, 255)); 
                height_value = 16;
                break;
            case 2: // Attack
                draw_set_color(make_color_rgb(24, 255, 0)); 
                height_value = 24;
                break;
            case 3: // Selected
                draw_set_color(make_color_rgb(32, 0, 255)); 
                height_value = 32;
                break;
            case 4: // Keyboard cursor
                draw_set_color(make_color_rgb(255, 255, 0)); 
                height_value = 255;
                break;
        }
        
        // Draw filled hexagon with height
        draw_set_alpha(0.3);
        draw_hexagon(x_pos, y_pos, hex_size, true);
        
        // Draw outline
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(height_value, height_value, height_value));
        draw_hexagon(x_pos, y_pos, hex_size, false);
    }
}