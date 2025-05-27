/// @description Initialize grid manager
// Grid settings
grid_width = 15;
grid_height = 12;
hex_size = 32;
hex_width = hex_size * 2;
hex_height = hex_size * sqrt(3);
hex_depth = 16; // New: Height of the hexagon in 3D space

// Grid offset for centering
grid_offset_x = room_width / 2 - (grid_width * hex_width * 0.75) / 2;
grid_offset_y = room_height / 2 - (grid_height * hex_height) / 2;
base_z = 0; // New: Base Z position for the grid

// Initialize 3D vertex format and buffer
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
global.vformat = vertex_format_end();
global.vbuff = vertex_create_buffer();

// Grid array to store unit references
grid = array_create(grid_width);
for (var i = 0; i < grid_width; i++) {
    grid[i] = array_create(grid_height, noone);
}

// Pathfinding grid for movement calculation
movement_grid = array_create(grid_width);
for (var i = 0; i < grid_width; i++) {
    movement_grid[i] = array_create(grid_height, -1);
}

// Visual grid for highlighting
highlight_grid = array_create(grid_width);
for (var i = 0; i < grid_width; i++) {
    highlight_grid[i] = array_create(grid_height, 0);
}

// Initialize hex directions for pathfinding (axial coordinates - consistent for all hexes)
hex_directions = [
    [1, 0], [1, -1], [0, -1], [-1, 0], [-1, 1], [0, 1]
];

// New: Terrain height map (for varying hex heights)
terrain_height = array_create(grid_width);
for (var i = 0; i < grid_width; i++) {
    terrain_height[i] = array_create(grid_height, 0);
}

// New: Initialize random terrain heights for visual interest
for (var i = 0; i < grid_width; i++) {
    for (var j = 0; j < grid_height; j++) {
        // Generate some slight variations in height
        terrain_height[i][j] = random_range(-4, 4);
    }
}