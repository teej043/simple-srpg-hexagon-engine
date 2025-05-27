/// @description Insert description here
// You can write your code in this editor

// Grid settings
grid_width = 15;
grid_height = 12;
hex_size = 32;
hex_width = hex_size * 2;
hex_height = hex_size * sqrt(3);

// Grid offset for centering
grid_offset_x = 100;
grid_offset_y = 100;

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