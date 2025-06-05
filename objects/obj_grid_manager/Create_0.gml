/// @description Initialize grid manager
depth=1;

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

// Surface rendering for performance optimization
base_grid_surface = -1;        // Surface for static grid base
highlight_surface = -1;        // Surface for dynamic highlights
surface_needs_update = true;   // Flag to redraw surfaces
highlight_needs_update = true; // Flag to redraw highlight surface

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

// Previous highlight state for change detection
prev_highlight_grid = array_create(grid_width);
for (var i = 0; i < grid_width; i++) {
    prev_highlight_grid[i] = array_create(grid_height, 0);
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

// Create initial surfaces using the new parameterized functions
base_grid_surface = create_base_grid_surface(base_grid_surface, grid_width, grid_height, hex_size, room_width, room_height);
highlight_surface = create_highlight_surface(highlight_surface, grid_width, grid_height, hex_size, highlight_grid, room_width, room_height);
update_prev_highlights_array(grid_width, grid_height, highlight_grid, prev_highlight_grid); // Update the previous state after creating highlight surface
surface_needs_update = false;
highlight_needs_update = false; 