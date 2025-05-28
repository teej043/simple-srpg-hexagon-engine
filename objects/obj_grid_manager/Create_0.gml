/// @description Insert description here
// You can write your code in this editor

/// @description Initialize grid manager


// Grid settings - these can be modified to change grid size
hex_size = 45;  // Base size of hexagons
grid_width = 20;  // Default width
grid_height = 15; // Default height

// Calculate hex dimensions (for flat-topped hexagons)
hex_width = hex_size * sqrt(3);
hex_height = hex_size * 2;

// Calculate grid offset to center the grid (adjusted for flat-topped with offset rows)
var total_width = hex_width * (grid_width + 0.5);  // Add 0.5 for offset rows
var total_height = hex_size * (grid_height * 1.5);
grid_offset_x = (room_width - total_width) / 2;
grid_offset_y = (room_height - total_height) / 2;

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

// Initialize hex directions for flat-topped hexagons
// For even rows: [q, r] offsets
even_hex_directions = [
    [1, 0],   // right
    [0, 1],   // bottom right
    [-1, 1],  // bottom left
    [-1, 0],  // left
    [-1, -1], // top left
    [0, -1]   // top right
];

// For odd rows: [q, r] offsets
odd_hex_directions = [
    [1, 0],   // right
    [1, 1],   // bottom right
    [0, 1],   // bottom left
    [-1, 0],  // left
    [0, -1],  // top left
    [1, -1]   // top right
];

// Function to get the correct hex directions based on row
function get_hex_directions(row) {
    return (row % 2 == 0) ? even_hex_directions : odd_hex_directions;
}

// Function to resize grid
function resize_grid(new_width, new_height) {
    // Store old dimensions
    var old_width = grid_width;
    var old_height = grid_height;
    
    // Update dimensions
    grid_width = new_width;
    grid_height = new_height;
    
    // Recalculate grid offset (adjusted for flat-topped with offset rows)
    var total_width = hex_width * (grid_width + 0.5);  // Add 0.5 for offset rows
    var total_height = hex_size * (grid_height * 1.5);
    grid_offset_x = (room_width - total_width) / 2;
    grid_offset_y = (room_height - total_height) / 2;
    
    // Resize grids
    var new_grid = array_create(grid_width);
    var new_movement_grid = array_create(grid_width);
    var new_highlight_grid = array_create(grid_width);
    
    for (var i = 0; i < grid_width; i++) {
        new_grid[i] = array_create(grid_height, noone);
        new_movement_grid[i] = array_create(grid_height, -1);
        new_highlight_grid[i] = array_create(grid_height, 0);
        
        // Copy existing data if within old bounds
        for (var j = 0; j < grid_height; j++) {
            if (i < old_width && j < old_height) {
                new_grid[i][j] = grid[i][j];
                new_movement_grid[i][j] = movement_grid[i][j];
                new_highlight_grid[i][j] = highlight_grid[i][j];
            }
        }
    }
    
    // Update grid references
    grid = new_grid;
    movement_grid = new_movement_grid;
    highlight_grid = new_highlight_grid;
    
    // Update unit positions
    with (obj_unit) {
        if (grid_x >= grid_width || grid_y >= grid_height) {
            instance_destroy();
        } else {
            scr_unit_update_pixel_position(id);
        }
    }
}