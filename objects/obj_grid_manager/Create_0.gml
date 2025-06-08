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

// Terrain system
terrain_grid = array_create(grid_width);
for (var i = 0; i < grid_width; i++) {
    terrain_grid[i] = array_create(grid_height, "plain"); // Default to plain terrain
}

// Terrain sprite mapping
terrain_sprites = {
    "plain": spr_hex_plain,
    "water": spr_hex_water,
    "road": spr_hex_road
};

// Initialize terrain layout
function setup_terrain_layout() {
    // Calculate center positions
    var center_x = floor(grid_width / 2);
    var center_y = floor(grid_height / 2);
    
    // Create horizontal water line (8x2) - centered horizontally
    var water_start_x = center_x - 4; // Start 4 hexes to the left of center
    var water_y1 = center_y - 1;     // One row above center
    var water_y2 = center_y;         // Center row
    
    for (var i = 0; i < 8; i++) {
        var water_x = water_start_x + i;
        if (water_x >= 0 && water_x < grid_width) {
            if (water_y1 >= 0 && water_y1 < grid_height) {
                terrain_grid[water_x][water_y1] = "water";
            }
            if (water_y2 >= 0 && water_y2 < grid_height) {
                terrain_grid[water_x][water_y2] = "water";
            }
        }
    }
    
    // Create vertical road line (1x8) - centered vertically
    var road_x = center_x;
    var road_start_y = center_y - 4; // Start 4 hexes above center
    
    for (var i = 0; i < 8; i++) {
        var road_y = road_start_y + i;
        if (road_y >= 0 && road_y < grid_height) {
            terrain_grid[road_x][road_y] = "road";
        }
    }
}

// Function to get terrain type at position
function get_terrain_at(q, r) {
    if (q >= 0 && q < grid_width && r >= 0 && r < grid_height) {
        return terrain_grid[q][r];
    }
    return "plain"; // Default for out of bounds
}

// Function to get sprite for terrain type
function get_terrain_sprite(terrain_type) {
    return variable_struct_get(terrain_sprites, terrain_type) ?? spr_hex_plain;
}

// Terrain movement costs - base costs for different terrains
terrain_movement_costs = {
    "plain": 1,
    "water": 2,    // Water is harder to traverse but not impassable
    "road": 0.5    // Roads allow faster movement - 2 road hexes = 1 movement point
};

// Function to get movement cost for terrain (can be modified by unit type later)
function get_terrain_movement_cost(unit, terrain_type) {
    // SKYHIGH and SKYLOW units ignore all terrain effects
    if (unit.move_type == MOVETYPE.SKYHIGH || unit.move_type == MOVETYPE.SKYLOW) {
        return 1; // Always base cost for flying units
    }
    
    // Get base terrain cost for GROUND units only
    var base_cost = variable_struct_get(terrain_movement_costs, terrain_type) ?? 1;
    
    // For now, return base cost - later we can add unit-specific modifiers
    // TODO: Add unit terrain effects like:
    // if (unit.unit_type == "archer" && terrain_type == "forest") base_cost -= 1;
    
    return max(0.5, base_cost); // Minimum cost of 0.5 to prevent infinite movement
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

// Setup terrain layout
setup_terrain_layout(); 