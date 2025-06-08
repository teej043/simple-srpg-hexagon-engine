/// @description Sprite-based hex grid rendering
draw_clear(#4E9943);

// Draw terrain hexes first (base layer)
for (var q = 0; q < grid_width; q++) {
    for (var r = 0; r < grid_height; r++) {
        var pos = hex_to_pixel(q, r);
        var terrain_type = get_terrain_at(q, r);
        var terrain_sprite = get_terrain_sprite(terrain_type);
        
        // Draw terrain sprite
        draw_sprite(terrain_sprite, 0, pos[0], pos[1]);
    }
}

// Draw highlight overlays using spr_hex with colors and alpha
for (var q = 0; q < grid_width; q++) {
    for (var r = 0; r < grid_height; r++) {
        var highlight_type = highlight_grid[q][r];
        
        // Only draw highlights for non-zero values
        if (highlight_type > 0) {
            var pos = hex_to_pixel(q, r);
            var highlight_color = c_white;
            var highlight_alpha = 0.6;
            
            // Set color based on highlight type
            switch (highlight_type) {
                case 1: highlight_color = c_blue; break;    // Movement
                case 2: highlight_color = c_red; break;     // Attack
                case 3: highlight_color = c_green; break;   // Selected
                case 4: highlight_color = c_yellow; break;  // Keyboard cursor
                default: highlight_color = c_white; break;
            }
            
            // Draw colored highlight overlay
            draw_sprite_ext(spr_hex, 0, pos[0], pos[1], 1, 1, 0, highlight_color, highlight_alpha);
        }
    }
}